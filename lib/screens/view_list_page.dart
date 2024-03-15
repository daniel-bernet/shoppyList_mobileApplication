import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/product_component.dart';
import '../providers/shopping_list_provider.dart';

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
    final _shoppingLists = shoppingListProvider.shoppingLists;
    
    // Ensuring _selectedListId is still valid or resetting it
    if (_shoppingLists == null || !_shoppingLists.any((list) => list['id'] == _selectedListId)) {
      _selectedListId = _shoppingLists?.isNotEmpty == true ? _shoppingLists?.first['id'] : null;
    }

    final _productDetails = _selectedListId != null ? shoppingListProvider.productDetails[_selectedListId!] : null;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_shoppingLists != null && _shoppingLists.isNotEmpty) ...[
              DropdownButtonFormField<String>(
                value: _selectedListId,
                decoration: const InputDecoration(labelText: 'Select List'),
                items: _shoppingLists.map((list) {
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
            ],
            if (_productDetails != null)
              ..._productDetails.map((product) => ProductComponent(
                    listId: _selectedListId!,
                    productId: product['id'],
                    quantity: product['quantity'].toString(),
                    unit: product['unit_of_measurement'],
                    productName: product['name'],
                    creator: product['creator'],
                    createdAt: product['created_at'],
                    lastEditedAt: product['updated_at'],
                    onChange: () => shoppingListProvider.fetchProductDetails(_selectedListId!),
                  )).toList(),
          ],
        ),
      ),
    );
  }
}

