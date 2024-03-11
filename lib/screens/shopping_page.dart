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
                return Container(
                  margin: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color:
                        Colors.lightBlue[50], // Choose the shade that fits best
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: Colors.lightBlue.shade100),
                  ),
                  child: ExpansionTile(
                    title: Text(list['title'],
                        style: Theme.of(context).textTheme.titleMedium),
                    children: products.map<Widget>((product) {
                      return ProductListItem(
                        productId: product['id'],
                        productName: product['name'],
                        quantity: product['quantity'].toString(),
                        unit: product['unit_of_measurement'],
                        onChecked: (isChecked) => _handleProductCheck(
                            list['id'], product['id'], isChecked),
                      );
                    }).toList()
                      ..add(
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: () => _finishShopping(list['id']),
                            child: const Text('Finish Shopping'),
                          ),
                        ),
                      ),
                  ),
                );
              },
            ),
    );
  }
}
