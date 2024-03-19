import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localization.dart';
import '../providers/shopping_list_provider.dart';

class ProductList extends StatefulWidget {
  final String listId;
  final String title;

  const ProductList({
    super.key,
    required this.listId,
    required this.title,
  });

  @override
  ProductListState createState() => ProductListState();
}

class ProductListState extends State<ProductList> {
  late Map<String, bool> _checkedProducts;

  @override
  void initState() {
    super.initState();
    _initializeCheckedProducts();
  }

  void _initializeCheckedProducts() {
    final provider = Provider.of<ShoppingListProvider>(context, listen: false);
    _checkedProducts = {
      for (var product in provider.productDetails[widget.listId] ?? [])
        product['id']: false,
    };
  }

  void _toggleChecked(String productId, bool? value) {
    setState(() {
      _checkedProducts[productId] = value!;
    });
  }

  void _finishShopping() async {
    final provider = Provider.of<ShoppingListProvider>(context, listen: false);
    final List<String> checkedProductIds = _checkedProducts.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    if (checkedProductIds.isNotEmpty) {
      await provider.deleteMultipleProductsFromShoppingList(
          widget.listId, checkedProductIds);
      _initializeCheckedProducts();
    }
  }

  String _getLocalizedUnit(String? unit, BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);
    if (unit == null || appLocalizations.translate(unit) == unit) {
      return "?unit?";
    }
    return appLocalizations.translate(unit);
  }

  void _showFinishShoppingConfirmation(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(appLocalizations.translate('finishShopping')),
          content: Text(appLocalizations.translate('areYouSureFinishShopping')),
          actions: <Widget>[
            TextButton(
              child: Text(appLocalizations.translate('cancel')),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text(appLocalizations.translate('confirm'),
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontWeight: FontWeight.bold)),
              onPressed: () {
                _finishShopping();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);
    final provider = Provider.of<ShoppingListProvider>(context);
    final products = provider.productDetails[widget.listId] ?? [];

    return Card(
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title:
              Text(widget.title, style: Theme.of(context).textTheme.titleLarge),
          children: [
            ...products.map((product) => ListTile(
                  leading: Checkbox(
                    value: _checkedProducts[product['id']],
                    onChanged: (bool? value) {
                      _toggleChecked(product['id'], value);
                    },
                  ),
                  title: Text(
                      '${product['name']} - ${product['quantity']} ${_getLocalizedUnit(product['unit_of_measurement'], context)}'),
                )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                onPressed: () => _showFinishShoppingConfirmation(context),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.shopping_cart_checkout),
                    const SizedBox(width: 8.0),
                    Text(appLocalizations.translate('finishShopping')),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
