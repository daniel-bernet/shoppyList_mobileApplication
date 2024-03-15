import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  late Map<String, bool> _checkedProducts;

  @override
  void initState() {
    super.initState();
    _initializeCheckedProducts();
  }

  void _initializeCheckedProducts() {
    final provider = Provider.of<ShoppingListProvider>(context, listen: false);
    _checkedProducts = {
      for (var product in provider.productDetails[widget.listId] ?? []) product['id']: false,
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
      await provider.deleteMultipleProductsFromShoppingList(widget.listId, checkedProductIds);
      _initializeCheckedProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ShoppingListProvider>(context);
    final _products = provider.productDetails[widget.listId] ?? [];

    return Card(
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text(widget.title, style: Theme.of(context).textTheme.titleLarge),
          children: [
            ..._products.map((product) => ListTile(
                  leading: Checkbox(
                    value: _checkedProducts[product['id']],
                    onChanged: (bool? value) {
                      _toggleChecked(product['id'], value);
                    },
                  ),
                  title: Text('${product['name']} - ${product['quantity']} ${product['unit_of_measurement']}'),
                )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                onPressed: _finishShopping,
                child: const Text('Finish Shopping'),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
