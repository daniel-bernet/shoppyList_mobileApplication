import 'package:app/services/api_service.dart';
import 'package:flutter/material.dart';

class ShoppingListProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<dynamic>? shoppingLists;
  Map<String, List<dynamic>?> productDetails = {};

  ShoppingListProvider() {
    fetchShoppingListsAndProducts();
  }

  Future<void> fetchShoppingListsAndProducts() async {
    await fetchShoppingLists();
    if (shoppingLists != null) {
      for (var list in shoppingLists!) {
        await fetchProductDetails(list['id']);
      }
    }
  }

  Future<void> fetchShoppingLists() async {
    shoppingLists = await _apiService.getShoppingLists();
    notifyListeners();
  }

  Future<void> fetchProductDetails(String listId) async {
    final details = await _apiService.getProductDetails(listId);
    if (details != null) {
      productDetails[listId] = details;
    }
    notifyListeners();
  }

  Future<bool> createShoppingList(String title) async {
    final success = await _apiService.createShoppingList(title);
    if (success) {
      await fetchShoppingLists();
    }
    return success;
  }

  Future<bool> addProductToList(
      String listId, String name, String quantity, String unit) async {
    final success = await _apiService.addProductToShoppingList(
        listId, name, quantity, unit);
    if (success) {
      await fetchProductDetails(listId);
    }
    return success;
  }

  Future<bool> deleteMultipleProductsFromShoppingList(
      String listId, List<String> productIds) async {
    final success = await _apiService.deleteMultipleProductsFromShoppingList(
        listId, productIds);
    if (success) {
      await fetchProductDetails(listId);
    }
    return success;
  }
}
