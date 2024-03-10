import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../utils/helpers/snackbar_helper.dart';

class EditListPage extends StatefulWidget {
  final String listId;
  final String listTitle;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> collaborators;

  const EditListPage({
    super.key,
    required this.listId,
    required this.listTitle,
    required this.createdAt,
    required this.updatedAt,
    required this.collaborators,
  });

  @override
  State<EditListPage> createState() => _EditListPageState();
}

class _EditListPageState extends State<EditListPage> {
  final ApiService _apiService = ApiService();
  final TextEditingController _collaboratorEmailController = TextEditingController();

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
        widget.collaborators.add(email);
      });
      _collaboratorEmailController.clear();
    } else {
      SnackbarHelper.showSnackBar('Failed to add collaborator', isError: true);
    }
  }

  void _removeCollaborator(String email) async {
    final success = await _apiService.removeCollaborator(widget.listId, email);
    if (success) {
      SnackbarHelper.showSnackBar('Collaborator removed successfully');
      setState(() {
        widget.collaborators.remove(email);
      });
    } else {
      SnackbarHelper.showSnackBar('Failed to remove collaborator', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.listTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Created at: ${widget.createdAt}'),
            Text('Updated at: ${widget.updatedAt}'),
            const SizedBox(height: 20),
            const Text('Collaborators:'),
            for (var collaborator in widget.collaborators)
              ListTile(
                title: Text(collaborator),
                trailing: IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: () => _removeCollaborator(collaborator),
                ),
              ),
            TextField(
              controller: _collaboratorEmailController,
              decoration: const InputDecoration(
                labelText: 'Collaborator Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addCollaborator,
              child: const Text('Add Collaborator'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _collaboratorEmailController.dispose();
    super.dispose();
  }
}
