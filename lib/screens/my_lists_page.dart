import 'package:flutter/material.dart';
import 'package:app/services/api_service.dart';
import 'package:app/utils/helpers/snackbar_helper.dart';
import 'package:app/components/list_component.dart';

class MyListsPage extends StatefulWidget {
  const MyListsPage({super.key});

  @override
  State<MyListsPage> createState() => _MyListsPageState();
}

class _MyListsPageState extends State<MyListsPage> {
  final TextEditingController _listTitleController = TextEditingController();
  final ApiService _apiService = ApiService();
  List<dynamic>? _shoppingLists;

  @override
  void initState() {
    super.initState();
    _fetchLists();
  }

  void _fetchLists() async {
    var shoppingLists = await _apiService.getShoppingLists();
    setState(() {
      _shoppingLists = shoppingLists;
    });
  }

  void _createList() async {
    final title = _listTitleController.text.trim();
    if (title.isEmpty) {
      SnackbarHelper.showSnackBar('Please enter a list title', isError: true);
      return;
    }

    final success = await _apiService.createShoppingList(title);
    if (success) {
      SnackbarHelper.showSnackBar('List created successfully');
      _listTitleController.clear();
      _fetchLists();
    } else {
      SnackbarHelper.showSnackBar('Failed to create list', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
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
              onPressed: _createList,
              child: const Text('Create List'),
            ),
            const SizedBox(height: 20),
            Expanded(
                child: _shoppingLists == null
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: _shoppingLists!.length,
                        itemBuilder: (context, index) {
                          var list = _shoppingLists![index];
                          return ListComponent(
                            title: list['title'],
                            listId: list['id'],
                            createdAt: DateTime.parse(list['created_at']),
                            updatedAt: DateTime.parse(list['updated_at']),
                            collaborators: list['collaborators'].cast<String>(),
                            isOwner: list['is_owner'],
                            fetchLists: _fetchLists,
                          );
                        },
                      )),
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
