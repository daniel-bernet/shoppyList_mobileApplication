import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/shopping_list_provider.dart';
import '../utils/helpers/snackbar_helper.dart';
import '../l10n/app_localization.dart';

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
    final appLocalizations = AppLocalizations.of(context);

    if (_selectedList == null ||
        _selectedUnit == null ||
        _nameController.text.isEmpty ||
        _quantityController.text.isEmpty) {
      SnackbarHelper.showSnackBar(appLocalizations.translate('pleaseFillAllFields'), isError: true);
      return;
    }

    final success = await provider.addProductToList(_selectedList!,
        _nameController.text, _quantityController.text, _selectedUnit!);
    if (success) {
      SnackbarHelper.showSnackBar(appLocalizations.translate('productAddedSuccessfully'));
      _nameController.clear();
      _quantityController.clear();
      if (!provider.shoppingLists!.any((list) => list['id'] == _selectedList)) {
        _selectedList = null;
      }
    } else {
      SnackbarHelper.showSnackBar(appLocalizations.translate('failedToAddProduct'), isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ShoppingListProvider>(context);
    final shoppingLists = provider.shoppingLists;
    final appLocalizations = AppLocalizations.of(context);

    if (_selectedList != null &&
        !shoppingLists!.any((list) => list['id'] == _selectedList)) {
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
              decoration: InputDecoration(labelText: appLocalizations.translate('productName')),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _quantityController,
              decoration: InputDecoration(labelText: appLocalizations.translate('quantity')),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedUnit,
              decoration: InputDecoration(labelText: appLocalizations.translate('unitOfMeasurement')),
              items: ['gram', 'kiloGram', 'deciLitre', 'litre', 'piece'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(appLocalizations.translate(value)),
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
              decoration: InputDecoration(labelText: appLocalizations.translate('shoppingList')),
              hint: shoppingLists == null || shoppingLists.isEmpty
                  ? Text(appLocalizations.translate("noListsAvailable"))
                  : null,
              items: shoppingLists?.map((list) {
                    return DropdownMenuItem<String>(
                      value: list['id'],
                      child: Text(list['title']),
                    );
                  }).toList() ??
                  [],
              onChanged: (shoppingLists == null || shoppingLists.isEmpty)
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
              child: Text(appLocalizations.translate('addProduct')),
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
