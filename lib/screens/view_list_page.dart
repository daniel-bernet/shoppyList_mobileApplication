import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../components/product_component.dart';

class ViewListPage extends StatefulWidget {
  const ViewListPage({super.key});

  @override
  State<ViewListPage> createState() => _ViewListPageState();
}

class _ViewListPageState extends State<ViewListPage> {
  final ApiService _apiService = ApiService();
  String? _selectedListId;
  List<dynamic>? _shoppingLists;
  List<dynamic>? _productDetails;

  @override
  void initState() {
    super.initState();
    _fetchShoppingLists();
  }

  void _fetchShoppingLists() async {
    var shoppingLists = await _apiService.getShoppingLists();
    setState(() {
      _shoppingLists = shoppingLists;
      if (shoppingLists != null && shoppingLists.isNotEmpty) {
        _selectedListId = shoppingLists.first['id'];
        _fetchProductDetails(_selectedListId!);
      }
    });
  }

  void _fetchProductDetails(String listId) async {
    var products = await _apiService.getProductDetails(listId);
    setState(() {
      _productDetails = products;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_shoppingLists != null) ...[
              DropdownButtonFormField<String>(
                value: _selectedListId,
                decoration: const InputDecoration(labelText: 'Select List'),
                items: _shoppingLists!.map((list) {
                  return DropdownMenuItem<String>(
                    value: list['id'],
                    child: Text(list['title']),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedListId = newValue;
                    _fetchProductDetails(_selectedListId!);
                  });
                },
              ),
              const SizedBox(height: 20),
            ],
            _productDetails == null
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    primary: false,
                    shrinkWrap:
                        true,
                    itemCount: _productDetails!.length,
                    itemBuilder: (context, index) {
                      var product = _productDetails![index];
                      return ProductComponent(
                        listId: _selectedListId!,
                        productId: product['id'],
                        quantity: product['quantity'].toString(),
                        unit: product['unit_of_measurement'],
                        productName: product['name'],
                        creator: product['creator'],
                        createdAt: product['created_at'],
                        lastEditedAt: product['updated_at'],
                        onEdit: () {
                          _fetchShoppingLists();
                        },
                        onDelete: () {
                          _fetchProductDetails(_selectedListId!);
                        },
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
