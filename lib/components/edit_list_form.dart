import 'package:flutter/material.dart';
import 'package:app/l10n/app_localization.dart';
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
    final appLocalizations = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ReusableAlertDialog(
          title: appLocalizations.translate('confirmDeletion'),
          content: appLocalizations.translate('areYouSureDeleteList'),
          actions: <Widget>[
            TextButton(
              child: Text(appLocalizations.translate('cancel')),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text(
                appLocalizations.translate('deleteList'),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
    if (!mounted) return;
    final appLocalizations = AppLocalizations.of(context);
    if (success) {
      widget.fetchLists();
      SnackbarHelper.showSnackBar(
          appLocalizations.translate('listDeletedSuccessfully'));
      if (mounted) Navigator.of(context).pop();
    } else {
      SnackbarHelper.showSnackBar(
          appLocalizations.translate('failedToDeleteProduct'),
          isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(
          '${appLocalizations.translate('edit')} ${widget.initialListTitle}'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _collaboratorEmailController,
              decoration: InputDecoration(
                labelText: appLocalizations.translate('addCollaborator'),
                hintText: appLocalizations.translate('enterCollaboratorEmail'),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addCollaborator,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              appLocalizations.translate('collaborators'),
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
                : Text(appLocalizations.translate('noCollaboratorsAddedYet'),
                    style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _showDeleteConfirmation,
          style: TextButton.styleFrom(),
          child: Text(appLocalizations.translate('deleteList')),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(appLocalizations.translate('close')),
        ),
      ],
    );
  }

  void _addCollaborator() async {
    final appLocalizations = AppLocalizations.of(context);
    final email = _collaboratorEmailController.text.trim();
    if (email.isEmpty) {
      SnackbarHelper.showSnackBar(
          appLocalizations.translate('pleaseEnterEmailAddress'),
          isError: true);
      return;
    }

    final success = await _apiService.addCollaborator(widget.listId, email);
    if (success) {
      SnackbarHelper.showSnackBar(
          appLocalizations.translate('collaboratorAddedSuccessfully'));
      setState(() {
        _collaborators.add(email);
      });
      _collaboratorEmailController.clear();
      widget.fetchLists();
    } else {
      SnackbarHelper.showSnackBar(
          appLocalizations.translate('failedToAddCollaborator'),
          isError: true);
    }
  }

  void _removeCollaborator(String email) async {
    final appLocalizations = AppLocalizations.of(context);
    final success = await _apiService.removeCollaborator(widget.listId, email);
    if (success) {
      SnackbarHelper.showSnackBar(
          appLocalizations.translate('collaboratorRemovedSuccessfully'));
      setState(() {
        _collaborators.removeWhere((collab) => collab == email);
      });
      widget.fetchLists();
    } else {
      SnackbarHelper.showSnackBar(
          appLocalizations.translate('failedToRemoveCollaborator'),
          isError: true);
    }
  }

  @override
  void dispose() {
    _collaboratorEmailController.dispose();
    super.dispose();
  }
}
