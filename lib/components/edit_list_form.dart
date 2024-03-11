import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../utils/helpers/snackbar_helper.dart';
import '../components/reusable_alert_dialog.dart';

class EditListForm extends StatefulWidget {
  final String listId;
  final String initialListTitle;
  final List<String> collaborators;
  final VoidCallback fetchLists;

  const EditListForm({
    super.key,
    required this.listId,
    required this.initialListTitle,
    required this.collaborators,
    required this.fetchLists,
  });

  @override
  State<EditListForm> createState() => _EditListFormState();
}

class _EditListFormState extends State<EditListForm> {
  final ApiService _apiService = ApiService();
  final TextEditingController _collaboratorEmailController =
      TextEditingController();
  late List<String> _collaborators;

  @override
  void initState() {
    super.initState();
    _collaborators = List.from(widget.collaborators);
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ReusableAlertDialog(
          title: 'Confirm Deletion',
          content: 'Are you sure you want to delete this list?',
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                _deleteList();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteList() async {
    final success = await _apiService.deleteShoppingList(widget.listId);
    if (success) {
      widget.fetchLists();
      SnackbarHelper.showSnackBar('List deleted successfully');
      Navigator.of(context).pop();
    } else {
      SnackbarHelper.showSnackBar('Failed to delete list', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit ${widget.initialListTitle}'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _collaboratorEmailController,
              decoration: InputDecoration(
                labelText: 'Add Collaborator',
                hintText: 'Enter collaborator email',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addCollaborator,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Collaborators:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            _collaborators.isNotEmpty
                ? Column(
                    children: _collaborators
                        .map((collaborator) => Card(
                              margin: const EdgeInsets.symmetric(vertical: 4.0),
                              child: ListTile(
                                title: Text(collaborator),
                                trailing: IconButton(
                                  icon: const Icon(Icons.remove_circle_outline),
                                  onPressed: () =>
                                      _removeCollaborator(collaborator),
                                ),
                              ),
                            ))
                        .toList(),
                  )
                : Text('No collaborators added yet',
                    style: Theme.of(context).textTheme.bodyText1),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _showDeleteConfirmation,
          style: TextButton.styleFrom(),
          child: const Text('Delete List'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }

  void _addCollaborator() async {
    final email = _collaboratorEmailController.text.trim();
    if (email.isEmpty) {
      SnackbarHelper.showSnackBar('Please enter an email', isError: true);
      return;
    }

    final success = await _apiService.addCollaborator(widget.listId, email);
    if (success) {
      SnackbarHelper.showSnackBar('Collaborator added successfully');
      setState(() {
        _collaborators.add(email);
      });
      _collaboratorEmailController.clear();
      widget.fetchLists();
    } else {
      SnackbarHelper.showSnackBar('Failed to add collaborator', isError: true);
    }
  }

  void _removeCollaborator(String email) async {
    final success = await _apiService.removeCollaborator(widget.listId, email);
    if (success) {
      SnackbarHelper.showSnackBar('Collaborator removed successfully');
      setState(() {
        _collaborators.removeWhere((collab) => collab == email);
      });
      widget.fetchLists();
    } else {
      SnackbarHelper.showSnackBar('Failed to remove collaborator',
          isError: true);
    }
  }

  @override
  void dispose() {
    _collaboratorEmailController.dispose();
    super.dispose();
  }
}
