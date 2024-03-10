import 'package:app/screens/edit_list_page.dart';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../utils/helpers/snackbar_helper.dart';

class ListComponent extends StatelessWidget {
  final String title;
  final String listId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> collaborators;
  final bool isOwner;
  final ApiService apiService = ApiService();

  ListComponent({
    super.key,
    required this.title,
    required this.listId,
    required this.createdAt,
    required this.updatedAt,
    required this.collaborators,
    required this.isOwner,
  });

  void _removeSelf(BuildContext context) async {
    final success = await apiService.leaveListAsCollaborator(listId);
    if (success) {
      SnackbarHelper.showSnackBar('Successfully left the list', isError: false);
      Navigator.of(context).pop();
    } else {
      SnackbarHelper.showSnackBar('Failed to leave the list', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text('Updated at: $updatedAt'),
        trailing: isOwner
            ? IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => EditListPage(
                    listId: listId,
                    listTitle: title,
                    createdAt: createdAt,
                    updatedAt: updatedAt,
                    collaborators: collaborators,
                  ),
                )),
              )
            : IconButton(
                icon: const Icon(Icons.exit_to_app),
                onPressed: () => _removeSelf(context),
              ),
      ),
    );
  }
}
