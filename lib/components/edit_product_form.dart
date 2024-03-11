import 'package:flutter/material.dart';

class EditProductForm extends StatefulWidget {
  final String productId;
  final String initialQuantity;
  final String initialUnit;
  final String initialProductName;
  final Function(String productId, String productName, String quantity, String unit) onFormSubmit;

  const EditProductForm({
    super.key,
    required this.productId,
    required this.initialQuantity,
    required this.initialUnit,
    required this.initialProductName,
    required this.onFormSubmit,
  });

  @override
  State<EditProductForm> createState() => _EditProductFormState();
}

class _EditProductFormState extends State<EditProductForm> {
  late TextEditingController _nameController;
  late TextEditingController _quantityController;
  String? _selectedUnit;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialProductName);
    _quantityController = TextEditingController(text: widget.initialQuantity);
    _selectedUnit = widget.initialUnit;
  }

  void _submitForm() {
    widget.onFormSubmit(
      widget.productId,
      _nameController.text,
      _quantityController.text,
      _selectedUnit!,
    );
    Navigator.of(context).pop(); // Dismiss the dialog
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Product'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Product Name'),
          ),
          TextField(
            controller: _quantityController,
            decoration: const InputDecoration(labelText: 'Quantity'),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
          ),
          DropdownButton<String>(
            value: _selectedUnit,
            onChanged: (String? newValue) {
              setState(() {
                _selectedUnit = newValue!;
              });
            },
            items: <String>['g', 'kg', 'dL', 'L', 'Stk.'].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _submitForm,
          child: const Text('Submit'),
        ),
      ],
    );
  }
}
