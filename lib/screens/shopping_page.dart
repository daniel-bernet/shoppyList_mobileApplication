import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/product_list_component.dart';
import '../providers/shopping_list_provider.dart';

class ShoppingPage extends StatefulWidget {
  const ShoppingPage({super.key});

  @override
  _ShoppingPageState createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final shoppingListProvider = Provider.of<ShoppingListProvider>(context);
    final shoppingLists = shoppingListProvider.shoppingLists;

    // Filter shopping lists to include only those with one or more products.
    final nonEmptyShoppingLists = shoppingLists?.where((list) {
      final products = shoppingListProvider.productDetails[list['id']];
      return products != null && products.isNotEmpty;
    }).toList();

    return Scaffold(
      body: nonEmptyShoppingLists == null || nonEmptyShoppingLists.isEmpty
          ? const Center(child: Text("No lists with items available"))
          : ListView.builder(
              itemCount: nonEmptyShoppingLists.length,
              itemBuilder: (context, index) {
                var list = nonEmptyShoppingLists[index];
                return ProductList(
                  listId: list['id'],
                  title: list['title'],
                );
              },
            ),
    );
  }
}
