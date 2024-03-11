import 'package:flutter/material.dart';

class ProductListItem extends StatefulWidget {
  final String productId;
  final String productName;
  final String quantity;
  final String unit;
  final Function(bool) onChecked;

  const ProductListItem({
    super.key,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unit,
    required this.onChecked,
  });

  @override
  _ProductListItemState createState() => _ProductListItemState();
}

class _ProductListItemState extends State<ProductListItem> {
  bool _isChecked = false;

  void _toggleChecked(bool? value) {
    setState(() {
      _isChecked = value!;
    });
    widget.onChecked(_isChecked);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: _isChecked,
        onChanged: _toggleChecked,
      ),
      title: Text('${widget.productName} - ${widget.quantity} ${widget.unit}'),
    );
  }
}
