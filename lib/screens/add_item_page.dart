import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../utils/helpers/snackbar_helper.dart';

class AddItemPage extends StatefulWidget {
  const AddItemPage({super.key});

  @override
  State<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  final ApiService _apiService = ApiService();
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  String? _selectedUnit;
  String? _selectedList;
  List<dynamic>? _shoppingLists;

  @override
  void initState() {
    super.initState();
    _fetchShoppingLists();
  }

  void _fetchShoppingLists() async {
    var shoppingLists = await _apiService.getShoppingLists();
    setState(() {
      _shoppingLists = shoppingLists;
    });
  }

  void _addProduct() async {
    if (_selectedList == null || _selectedUnit == null || _nameController.text.isEmpty || _quantityController.text.isEmpty) {
      SnackbarHelper.showSnackBar('Please fill all fields', isError: true);
      return;
    }

    final success = await _apiService.addProductToShoppingList(_selectedList!, _nameController.text, _quantityController.text, _selectedUnit!);
    if (success) {
      SnackbarHelper.showSnackBar('Product added successfully');
      _nameController.clear();
      _quantityController.clear();
    } else {
      SnackbarHelper.showSnackBar('Failed to add product', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
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
            TextField( // should only accept numbers!!!!!!!!!!!!!!!!
              controller: _quantityController,
              decoration: const InputDecoration(labelText: 'Quantity'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedUnit,
              decoration: const InputDecoration(labelText: 'Unit of Measurement'),
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
              items: _shoppingLists?.map((list) {
                return DropdownMenuItem<String>(
                  value: list['id'],
                  child: Text(list['title']),
                );
              }).toList(),
              onChanged: (newValue) {
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
