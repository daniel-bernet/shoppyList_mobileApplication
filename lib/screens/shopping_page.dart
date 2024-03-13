import 'package:app/components/product_list_component.dart';
import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ShoppingPage extends StatefulWidget {
  const ShoppingPage({super.key});

  @override
  _ShoppingPageState createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  final ApiService _apiService = ApiService();
  List<dynamic>? _shoppingLists;
  final Map<String, List<dynamic>> _shoppingListProducts = {};
  final Map<String, List<String>> _checkedProducts = {};

  @override
  void initState() {
    super.initState();
    _fetchShoppingLists();
  }

  void _fetchShoppingLists() async {
    var shoppingLists = await _apiService.getShoppingLists();
    if (shoppingLists != null) {
      for (var list in shoppingLists) {
        _fetchProductDetails(list['id']);
      }
    }
    setState(() {
      _shoppingLists = shoppingLists;
    });
  }

  void _fetchProductDetails(String listId) async {
    var products = await _apiService.getProductDetails(listId);
    setState(() {
      _shoppingListProducts[listId] = products ?? [];
      _checkedProducts[listId] = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _shoppingLists == null || _shoppingLists!.isEmpty
          ? const Center(child: Text("No lists available"))
          : ListView.builder(
              itemCount: _shoppingLists!.length,
              itemBuilder: (context, index) {
                var list = _shoppingLists![index];
                return (_shoppingListProducts[list['id']] ?? []).isNotEmpty
                ? ProductList(
                    listId: list['id'],
                    title: list['title'],
                    products: _shoppingListProducts[list['id']] ?? [],
                  )
                : const SizedBox.shrink();
              },
            ),
    );
  }
}
