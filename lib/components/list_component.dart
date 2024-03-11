import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../utils/helpers/snackbar_helper.dart';
import '../components/reusable_alert_dialog.dart';
import '../components/edit_list_form.dart';

class ListComponent extends StatelessWidget {
  final String title;
  final String listId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> collaborators;
  final bool isOwner;
  final VoidCallback fetchLists;
  final ApiService apiService = ApiService();

  ListComponent({
    super.key,
    required this.title,
    required this.listId,
    required this.createdAt,
    required this.updatedAt,
    required this.collaborators,
    required this.isOwner,
    required this.fetchLists,
  });

  void _showLeaveConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ReusableAlertDialog(
          title: 'Confirm',
          content: 'Are you sure you want to leave this list?',
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Leave'),
              onPressed: () {
                _removeSelf(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _removeSelf(BuildContext context) async {
    Navigator.of(context).pop();
    final success = await apiService.leaveListAsCollaborator(listId);
    if (success) {
      SnackbarHelper.showSnackBar('Successfully left the list', isError: false);
      fetchLists();
    } else {
      SnackbarHelper.showSnackBar('Failed to leave the list', isError: true);
    }
  }

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return EditListForm(
          listId: listId,
          initialListTitle: title,
          collaborators: collaborators,
          fetchLists: fetchLists,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text('Edited at: $updatedAt'),
        trailing: isOwner
            ? IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _showEditDialog(context),
              )
            : IconButton(
                icon: const Icon(Icons.exit_to_app),
                onPressed: () => _showLeaveConfirmation(context),
              ),
      ),
    );
  }
}
