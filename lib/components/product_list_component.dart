import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ProductList extends StatefulWidget {
  final String listId;
  final String title;
  final List<dynamic> products;

  const ProductList({
    super.key,
    required this.listId,
    required this.title,
    required this.products,
  });

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  late Map<String, bool> _checkedProducts;
  late List<dynamic> _products;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _products = List.from(widget.products);
    _initializeCheckedProducts();
  }

  void _initializeCheckedProducts() {
    _checkedProducts = {
      for (var product in _products) product['id']: false,
    };
  }

  void _toggleChecked(String productId, bool? value) {
    setState(() {
      _checkedProducts[productId] = value!;
    });
  }

  void _finishShopping() async {
    final List<String> checkedProductIds = _checkedProducts.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    if (checkedProductIds.isNotEmpty) {
      await _apiService.deleteMultipleProductsFromShoppingList(
          widget.listId, checkedProductIds);
      var fetchedProducts = await _apiService.getProductDetails(widget.listId);
      setState(() {
        _products = fetchedProducts ?? [];
        _initializeCheckedProducts();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title:
              Text(widget.title, style: Theme.of(context).textTheme.titleLarge),
          children: [
            ..._products.map((product) => ListTile(
                  leading: Checkbox(
                    value: _checkedProducts[product['id']],
                    onChanged: (bool? value) {
                      _toggleChecked(product['id'], value);
                    },
                  ),
                  title: Text(
                      '${product['name']} - ${product['quantity']} ${product['unit_of_measurement']}'),
                )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                onPressed: _finishShopping,
                child: const Text('Finish Shopping'),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
