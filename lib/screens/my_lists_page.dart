import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:intl/intl.dart';
import 'package:app/l10n/app_localization.dart';
import 'package:app/providers/shopping_list_provider.dart';
import 'package:app/utils/helpers/snackbar_helper.dart';
import 'package:app/components/list_component.dart';
import 'package:app/providers/timezone_provider.dart';

class MyListsPage extends StatefulWidget {
  const MyListsPage({super.key});

  @override
  State<MyListsPage> createState() => _MyListsPageState();
}

class _MyListsPageState extends State<MyListsPage> {
  final TextEditingController _listTitleController = TextEditingController();

  void _createList(ShoppingListProvider provider) async {
    final title = _listTitleController.text.trim();
    final appLocalizations = AppLocalizations.of(context);
    if (title.isEmpty) {
      SnackbarHelper.showSnackBar(appLocalizations.translate('pleaseFillAllFields'), isError: true);
      return;
    }

    final success = await provider.createShoppingList(title);
    if (success) {
      SnackbarHelper.showSnackBar(appLocalizations.translate('listCreatedSuccessfully'));
      _listTitleController.clear();
    } else {
      SnackbarHelper.showSnackBar(appLocalizations.translate('failedToCreateList'), isError: true);
    }
  }

  String _formatDateTime(String dateTimeStr, BuildContext context) {
    final timezoneProvider = Provider.of<TimezoneProvider>(context, listen: false);
    final String timezoneId = timezoneProvider.timezone;
    final DateFormat formatter = DateFormat('dd.MM.yyyy HH:mm');
    final DateTime dateTime = DateTime.parse(dateTimeStr).toUtc();
    final location = tz.getLocation(timezoneId);
    final tz.TZDateTime zonedTime = tz.TZDateTime.from(dateTime, location);

    return formatter.format(zonedTime);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ShoppingListProvider>(context);
    final appLocalizations = AppLocalizations.of(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _listTitleController,
              decoration: InputDecoration(
                labelText: appLocalizations.translate('listTitle'),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _createList(provider),
              child: Text(appLocalizations.translate('createList')),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: provider.shoppingLists == null
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: provider.shoppingLists!.length,
                      itemBuilder: (context, index) {
                        var list = provider.shoppingLists![index];
                        return ListComponent(
                          title: list['title'],
                          listId: list['id'],
                          createdAt: _formatDateTime(list['created_at'], context),
                          updatedAt: _formatDateTime(list['updated_at'], context),
                          collaborators: list['collaborators'].cast<String>(),
                          isOwner: list['is_owner'],
                          fetchLists: provider.fetchShoppingLists,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _listTitleController.dispose();
    super.dispose();
  }
}
