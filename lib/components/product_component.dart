import 'package:app/components/edit_product_form.dart';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../components/reusable_alert_dialog.dart';
import '../utils/helpers/snackbar_helper.dart';

class ProductComponent extends StatelessWidget {
  final String listId;
  final String productId;
  final String quantity;
  final String unit;
  final String productName;
  final String creator;
  final String createdAt;
  final String lastEditedAt;
  final VoidCallback onChange;

  const ProductComponent({
    super.key,
    required this.listId,
    required this.productId,
    required this.quantity,
    required this.unit,
    required this.productName,
    required this.creator,
    required this.createdAt,
    required this.lastEditedAt,
    required this.onChange,
  });

  void _deleteProduct(BuildContext context) async {
    ApiService apiService = ApiService();
    final success =
        await apiService.deleteProductFromShoppingList(listId, productId);
    if (success) {
      SnackbarHelper.showSnackBar('Product deleted successfully');
      onChange();
    } else {
      SnackbarHelper.showSnackBar('Failed to delete product', isError: true);
    }
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ReusableAlertDialog(
          title: 'Confirm Deletion',
          content: 'Are you sure you want to delete this product?',
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                _deleteProduct(context);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return EditProductForm(
          listId: listId,
          productId: productId,
          initialQuantity: quantity,
          initialUnit: unit,
          initialProductName: productName,
          onFormSubmit: onChange,
          creator: creator,
          createdAt: createdAt,
          lastEditedAt: lastEditedAt,
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(productName, style: Theme.of(context).textTheme.titleLarge),
        subtitle: Text('$quantity $unit', style: Theme.of(context).textTheme.bodySmall),
        trailing: Wrap(
          spacing: 12,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _showEditDialog(context),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _showDeleteConfirmation(context),
            ),
          ],
        ),
      ),
    );
  }
}