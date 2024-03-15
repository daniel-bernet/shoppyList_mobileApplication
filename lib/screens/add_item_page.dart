import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/shopping_list_provider.dart';
import '../utils/helpers/snackbar_helper.dart';

class AddItemPage extends StatefulWidget {
  const AddItemPage({super.key});

  @override
  State<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  String? _selectedUnit;
  String? _selectedList;

  void _addProduct() async {
    final provider = Provider.of<ShoppingListProvider>(context, listen: false);

    if (_selectedList == null ||
        _selectedUnit == null ||
        _nameController.text.isEmpty ||
        _quantityController.text.isEmpty) {
      SnackbarHelper.showSnackBar('Please fill all fields', isError: true);
      return;
    }

    final success = await provider.addProductToList(_selectedList!,
        _nameController.text, _quantityController.text, _selectedUnit!);
    if (success) {
      SnackbarHelper.showSnackBar('Product added successfully');
      _nameController.clear();
      _quantityController.clear();
      // Ensure the selected list and unit are retained, and available after the update.
      if (!provider.shoppingLists!.any((list) => list['id'] == _selectedList)) {
        _selectedList = null;
      }
    } else {
      SnackbarHelper.showSnackBar('Failed to add product', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ShoppingListProvider>(context);
    final _shoppingLists = provider.shoppingLists;

    // Validate and possibly update the selected list if it no longer exists.
    if (_selectedList != null &&
        !_shoppingLists!.any((list) => list['id'] == _selectedList)) {
      _selectedList = null;
    }

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Product Name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _quantityController,
              decoration: const InputDecoration(labelText: 'Quantity'),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedUnit,
              decoration:
                  const InputDecoration(labelText: 'Unit of Measurement'),
              items: ['g', 'kg', 'dL', 'L', 'Stk.'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedUnit = newValue;
                });
              },
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedList,
              decoration: const InputDecoration(labelText: 'Shopping List'),
              hint: _shoppingLists == null || _shoppingLists.isEmpty
                  ? const Text("No lists available")
                  : null,
              items: _shoppingLists?.map((list) {
                    return DropdownMenuItem<String>(
                      value: list['id'],
                      child: Text(list['title']),
                    );
                  }).toList() ??
                  [],
              onChanged: (_shoppingLists == null || _shoppingLists.isEmpty)
                  ? null
                  : (newValue) {
                      setState(() {
                        _selectedList = newValue;
                      });
                    },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addProduct,
              child: const Text('Add Product'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }
}
