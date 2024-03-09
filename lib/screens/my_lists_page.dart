// /lib/screens/my_lists_page.dart
import 'package:flutter/material.dart';
import 'package:app/services/api_service.dart';
import 'package:app/utils/helpers/snackbar_helper.dart';

class MyListsPage extends StatefulWidget {
  const MyListsPage({super.key});

  @override
  State<MyListsPage> createState() => _MyListsPageState();
}

class _MyListsPageState extends State<MyListsPage> {
  final TextEditingController _listTitleController = TextEditingController();
  final ApiService _apiService = ApiService();

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
    } else {
      SnackbarHelper.showSnackBar('Failed to create list', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Lists'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _listTitleController,
              decoration: const InputDecoration(
                labelText: 'List Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _createList,
              child: const Text('Create List'),
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
