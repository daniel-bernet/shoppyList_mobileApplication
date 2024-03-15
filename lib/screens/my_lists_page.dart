import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/providers/shopping_list_provider.dart';
import 'package:app/utils/helpers/snackbar_helper.dart';
import 'package:app/components/list_component.dart';

class MyListsPage extends StatefulWidget {
  const MyListsPage({super.key});

  @override
  State<MyListsPage> createState() => _MyListsPageState();
}

class _MyListsPageState extends State<MyListsPage> {
  final TextEditingController _listTitleController = TextEditingController();

  void _createList(ShoppingListProvider provider) async {
    final title = _listTitleController.text.trim();
    if (title.isEmpty) {
      SnackbarHelper.showSnackBar('Please enter a list title', isError: true);
      return;
    }

    final success = await provider.createShoppingList(title);
    if (success) {
      SnackbarHelper.showSnackBar('List created successfully');
      _listTitleController.clear();
    } else {
      SnackbarHelper.showSnackBar('Failed to create list', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ShoppingListProvider>(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _listTitleController,
              decoration: const InputDecoration(
                labelText: 'List Title',
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _createList(provider),
              child: const Text('Create List'),
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
                        createdAt: DateTime.parse(list['created_at']),
                        updatedAt: DateTime.parse(list['updated_at']),
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
