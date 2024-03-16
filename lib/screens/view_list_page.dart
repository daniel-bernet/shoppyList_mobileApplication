import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/product_component.dart';
import '../providers/shopping_list_provider.dart';
import '../l10n/app_localization.dart';

class ViewListPage extends StatefulWidget {
  const ViewListPage({super.key});

  @override
  State<ViewListPage> createState() => _ViewListPageState();
}

class _ViewListPageState extends State<ViewListPage> {
  String? _selectedListId;

  @override
  Widget build(BuildContext context) {
    final shoppingListProvider = Provider.of<ShoppingListProvider>(context);
    final shoppingLists = shoppingListProvider.shoppingLists;
    final appLocalizations = AppLocalizations.of(context);
    
    if (shoppingLists == null || !shoppingLists.any((list) => list['id'] == _selectedListId)) {
      _selectedListId = shoppingLists?.isNotEmpty == true ? shoppingLists?.first['id'] : null;
    }

    final productDetails = _selectedListId != null ? shoppingListProvider.productDetails[_selectedListId!] : null;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (shoppingLists != null && shoppingLists.isNotEmpty) ...[
              DropdownButtonFormField<String>(
                value: _selectedListId,
                decoration: InputDecoration(labelText: appLocalizations.translate('selectList')),
                items: shoppingLists.map((list) {
                  return DropdownMenuItem<String>(
                    value: list['id'],
                    child: Text(list['title']),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedListId = newValue;
                    shoppingListProvider.fetchProductDetails(newValue!);
                  });
                },
              ),
              const SizedBox(height: 20),
            ] else ...[
              Center(child: Text(appLocalizations.translate('noListsToDisplay'))),
            ],
            if (productDetails != null)
              ...productDetails.map((product) => ProductComponent(
                    listId: _selectedListId!,
                    productId: product['id'],
                    quantity: product['quantity'].toString(),
                    unit: product['unit_of_measurement'],
                    productName: product['name'],
                    creator: product['creator'],
                    createdAt: product['created_at'],
                    lastEditedAt: product['updated_at'],
                    onChange: () => shoppingListProvider.fetchProductDetails(_selectedListId!),
                  )),
          ],
        ),
      ),
    );
  }
}
