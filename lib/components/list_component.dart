import 'package:flutter/material.dart';
import 'package:app/l10n/app_localization.dart';
import '../services/api_service.dart';
import '../utils/helpers/snackbar_helper.dart';
import '../components/reusable_alert_dialog.dart';
import '../components/edit_list_form.dart';

class ListComponent extends StatelessWidget {
  final String title;
  final String listId;
  final String createdAt;
  final String updatedAt;
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
    final appLocalizations = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ReusableAlertDialog(
          title: appLocalizations.translate('confirm'),
          content: appLocalizations.translate('areYouSureLeaveList'),
          actions: <Widget>[
            TextButton(
              child: Text(appLocalizations.translate('cancel')),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text(
                appLocalizations.translate('leave'),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () => _removeSelf(context),
            ),
          ],
        );
      },
    );
  }

  void _removeSelf(BuildContext context) async {
    final appLocalizations = AppLocalizations.of(context);
    Navigator.of(context).pop();
    final success = await apiService.leaveListAsCollaborator(listId);
    if (success) {
      SnackbarHelper.showSnackBar(
          appLocalizations.translate('successfullyLeftList'));
      fetchLists();
    } else {
      SnackbarHelper.showSnackBar(
          appLocalizations.translate('failedToLeaveList'),
          isError: true);
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
    final appLocalizations = AppLocalizations.of(context);
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text('${appLocalizations.translate('lastEdit')}: $updatedAt'),
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
