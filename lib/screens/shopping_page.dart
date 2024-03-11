import 'package:app/values/app_colors.dart';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../components/product_list_item.dart';

class ShoppingPage extends StatefulWidget {
  const ShoppingPage({super.key});

  @override
  _ShoppingPageState createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  final ApiService _apiService = ApiService();
  List<dynamic>? _shoppingLists;
  Map<String, List<dynamic>> _shoppingListProducts = {};
  Map<String, List<String>> _checkedProducts = {};

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

  void _finishShopping(String listId) async {
    if (_checkedProducts[listId]?.isNotEmpty == true) {
      await _apiService.deleteMultipleProductsFromShoppingList(
          listId, _checkedProducts[listId]!);
      _fetchProductDetails(listId); // Refresh the products for this list
    }
  }

  void _handleProductCheck(String listId, String productId, bool isChecked) {
    setState(() {
      if (isChecked) {
        _checkedProducts[listId]?.add(productId);
      } else {
        _checkedProducts[listId]?.remove(productId);
      }
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
                var products = _shoppingListProducts[list['id']] ?? [];
                return Card(
                  child: ExpansionTile(
                    title: Text(list['title'], style: Theme.of(context).textTheme.titleLarge),
                    children: [
                      ...products.map((product) => ProductListItem(
                            productId: product['id'],
                            productName: product['name'],
                            quantity: product['quantity'].toString(),
                            unit: product['unit_of_measurement'],
                            onChecked: (isChecked) => _handleProductCheck(list['id'], product['id'], isChecked),
                          )),
                      if (products.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: ElevatedButton(
                            onPressed: () => _finishShopping(list['id']),
                            child: const Text('Finish Shopping'),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
