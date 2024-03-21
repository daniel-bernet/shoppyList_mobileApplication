import 'dart:convert';
import 'package:app/utils/helpers/navigation_helper.dart';
import 'package:app/values/app_routes.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
//  final String _baseUrl = 'https://kingseba.onnube.ch';
  final String _baseUrl = 'http://84.74.1.146:5000';
  final storage = const FlutterSecureStorage();

  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      await storage.deleteAll();
      final tokens = jsonDecode(response.body);
      await storage.write(key: 'jwtToken', value: tokens['access_token']);
      await storage.write(key: 'refreshToken', value: tokens['refresh_token']);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> register(String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      await storage.deleteAll();
      final tokens = jsonDecode(response.body);
      await storage.write(key: 'jwtToken', value: tokens['access_token']);
      await storage.write(key: 'refreshToken', value: tokens['refresh_token']);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> refreshToken() async {
    final refreshToken = await storage.read(key: 'refreshToken');
    if (refreshToken == null) {
      await logOut();
      return false;
    }

    final response = await http.post(
      Uri.parse('$_baseUrl/token/refresh'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $refreshToken',
      },
    );

    if (response.statusCode == 200) {
      final newJwtToken = jsonDecode(response.body)['access_token'];
      await storage.write(key: 'jwtToken', value: newJwtToken);
      return true;
    } else {
      await logOut();
      return false;
    }
  }

  Future<bool> validateToken() async {
    var jwtToken = await storage.read(key: 'jwtToken');
    if (jwtToken == null) {
      return false;
    }

    var response = await http.get(
      Uri.parse('$_baseUrl/validate-token'),
      headers: {
        'Authorization': 'Bearer $jwtToken',
      },
    );

    if (response.statusCode == 401) {
      final refreshSuccess = await refreshToken();
      if (!refreshSuccess) {
        return false;
      }

      jwtToken = await storage.read(key: 'jwtToken');
      response = await http.get(
        Uri.parse('$_baseUrl/validate-token'),
        headers: {
          'Authorization': 'Bearer $jwtToken',
        },
      );
    }

    return response.statusCode == 200;
  }

  Future<void> logOut() async {
    await storage
        .deleteAll();
    NavigationHelper.pushReplacementNamed(AppRoutes.login);
  }

  Future<bool> createShoppingList(String title) async {
    String? jwtToken = await storage.read(key: 'jwtToken');
    if (jwtToken == null) {
      return false;
    }

    var response = await http.post(
      Uri.parse('$_baseUrl/shopping_lists'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwtToken',
      },
      body: jsonEncode({'title': title}),
    );

    if (response.statusCode == 401) {
      final refreshSuccess = await refreshToken();
      if (!refreshSuccess) {
        return false;
      }

      jwtToken = await storage.read(key: 'jwtToken');
      response = await http.post(
        Uri.parse('$_baseUrl/shopping_lists'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwtToken',
        },
        body: jsonEncode({'title': title}),
      );
    }

    return response.statusCode == 201;
  }

  Future<List<dynamic>?> getShoppingLists() async {
    String? jwtToken = await storage.read(key: 'jwtToken');
    if (jwtToken == null) {
      return null;
    }

    var response = await http.get(
      Uri.parse('$_baseUrl/shopping_lists'),
      headers: {
        'Authorization': 'Bearer $jwtToken',
      },
    );

    if (response.statusCode == 401) {
      final refreshSuccess = await refreshToken();
      if (!refreshSuccess) {
        return null;
      }

      jwtToken = await storage.read(key: 'jwtToken');
      response = await http.get(
        Uri.parse('$_baseUrl/shopping_lists'),
        headers: {
          'Authorization': 'Bearer $jwtToken',
        },
      );
    }

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }

  Future<bool> addCollaborator(String listId, String email) async {
    String? jwtToken = await storage.read(key: 'jwtToken');
    if (jwtToken == null) {
      return false;
    }

    var response = await http.post(
      Uri.parse('$_baseUrl/shopping_lists/$listId/collaborators'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwtToken',
      },
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode == 401) {
      final refreshSuccess = await refreshToken();
      if (!refreshSuccess) {
        return false;
      }

      jwtToken = await storage.read(key: 'jwtToken');
      response = await http.post(
        Uri.parse('$_baseUrl/shopping_lists/$listId/collaborators'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwtToken',
        },
        body: jsonEncode({'email': email}),
      );
    }

    return response.statusCode == 200;
  }

  Future<bool> removeCollaborator(String listId, String email) async {
    String? jwtToken = await storage.read(key: 'jwtToken');
    if (jwtToken == null) {
      return false;
    }

    var response = await http.delete(
      Uri.parse('$_baseUrl/shopping_lists/$listId/collaborators/$email'),
      headers: {
        'Authorization': 'Bearer $jwtToken',
      },
    );

    if (response.statusCode == 401) {
      final refreshSuccess = await refreshToken();
      if (!refreshSuccess) {
        return false;
      }

      jwtToken = await storage.read(key: 'jwtToken');
      response = await http.delete(
        Uri.parse('$_baseUrl/shopping_lists/$listId/collaborators/$email'),
        headers: {
          'Authorization': 'Bearer $jwtToken',
        },
      );
    }

    return response.statusCode == 200;
  }

  Future<bool> leaveListAsCollaborator(String listId) async {
    String? jwtToken = await storage.read(key: 'jwtToken');
    if (jwtToken == null) {
      return false;
    }

    var response = await http.post(
      Uri.parse('$_baseUrl/shopping_lists/$listId/leave'),
      headers: {
        'Authorization': 'Bearer $jwtToken',
      },
    );

    if (response.statusCode == 401) {
      final refreshSuccess = await refreshToken();
      if (!refreshSuccess) {
        return false;
      }

      jwtToken = await storage.read(key: 'jwtToken');
      response = await http.post(
        Uri.parse('$_baseUrl/shopping_lists/$listId/leave'),
        headers: {
          'Authorization': 'Bearer $jwtToken',
        },
      );
    }

    return response.statusCode == 200;
  }

  Future<bool> deleteShoppingList(String listId) async {
    String? jwtToken = await storage.read(key: 'jwtToken');
    if (jwtToken == null) {
      return false;
    }

    var response = await http.delete(
      Uri.parse('$_baseUrl/shopping_lists/$listId'),
      headers: {
        'Authorization': 'Bearer $jwtToken',
      },
    );

    if (response.statusCode == 401) {
      final refreshSuccess = await refreshToken();
      if (!refreshSuccess) {
        return false;
      }

      jwtToken = await storage.read(key: 'jwtToken');
      response = await http.delete(
        Uri.parse('$_baseUrl/shopping_lists/$listId'),
        headers: {
          'Authorization': 'Bearer $jwtToken',
        },
      );
    }

    return response.statusCode == 200;
  }

  Future<bool> addProductToShoppingList(String listId, String name,
      String quantity, String unitOfMeasurement) async {
    String? jwtToken = await storage.read(key: 'jwtToken');
    if (jwtToken == null) {
      return false;
    }

    var response = await http.post(
      Uri.parse('$_baseUrl/shopping_lists/$listId/products'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwtToken',
      },
      body: jsonEncode({
        'name': name,
        'quantity': quantity,
        'unit_of_measurement': unitOfMeasurement,
      }),
    );

    if (response.statusCode == 401) {
      final refreshSuccess = await refreshToken();
      if (!refreshSuccess) {
        return false;
      }

      jwtToken = await storage.read(key: 'jwtToken');
      response = await http.post(
        Uri.parse('$_baseUrl/shopping_lists/$listId/products'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwtToken',
        },
        body: jsonEncode({
          'name': name,
          'quantity': quantity,
          'unit_of_measurement': unitOfMeasurement,
        }),
      );
    }

    return response.statusCode == 201;
  }

  Future<List<dynamic>?> getProductDetails(String listId) async {
    String? jwtToken = await storage.read(key: 'jwtToken');
    if (jwtToken == null) {
      return null;
    }

    var response = await http.get(
      Uri.parse('$_baseUrl/shopping_lists/$listId/products'),
      headers: {
        'Authorization': 'Bearer $jwtToken',
      },
    );

    if (response.statusCode == 401) {
      final refreshSuccess = await refreshToken();
      if (!refreshSuccess) {
        return null;
      }

      jwtToken = await storage.read(key: 'jwtToken');
      response = await http.get(
        Uri.parse('$_baseUrl/shopping_lists/$listId/products'),
        headers: {
          'Authorization': 'Bearer $jwtToken',
        },
      );
    }

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }

  Future<bool> deleteProductFromShoppingList(
      String listId, String productId) async {
    String? jwtToken = await storage.read(key: 'jwtToken');
    if (jwtToken == null) {
      return false;
    }

    var response = await http.delete(
      Uri.parse('$_baseUrl/shopping_lists/$listId/products/$productId'),
      headers: {
        'Authorization': 'Bearer $jwtToken',
      },
    );

    if (response.statusCode == 401) {
      final refreshSuccess = await refreshToken();
      if (!refreshSuccess) {
        return false;
      }

      jwtToken = await storage.read(key: 'jwtToken');
      response = await http.delete(
        Uri.parse('$_baseUrl/shopping_lists/$listId/products/$productId'),
        headers: {
          'Authorization': 'Bearer $jwtToken',
        },
      );
    }

    return response.statusCode == 200;
  }

  Future<bool> updateProductDetails(String listId, String productId,
      String name, String quantity, String unitOfMeasurement) async {
    String? jwtToken = await storage.read(key: 'jwtToken');
    if (jwtToken == null) {
      return false;
    }

    var response = await http.put(
      Uri.parse('$_baseUrl/shopping_lists/$listId/products/$productId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwtToken',
      },
      body: jsonEncode({
        'name': name,
        'quantity': quantity,
        'unit_of_measurement': unitOfMeasurement,
      }),
    );

    if (response.statusCode == 401) {
      final refreshSuccess = await refreshToken();
      if (!refreshSuccess) {
        return false;
      }

      jwtToken = await storage.read(key: 'jwtToken');
      response = await http.put(
        Uri.parse('$_baseUrl/shopping_lists/$listId/products/$productId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwtToken',
        },
        body: jsonEncode({
          'name': name,
          'quantity': quantity,
          'unit_of_measurement': unitOfMeasurement,
        }),
      );
    }

    return response.statusCode == 200;
  }

  Future<bool> deleteMultipleProductsFromShoppingList(
      String listId, List<String> productIds) async {
    String? jwtToken = await storage.read(key: 'jwtToken');
    if (jwtToken == null) {
      return false;
    }

    var response = await http.post(
      Uri.parse('$_baseUrl/shopping_lists/$listId/products/batch_delete'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwtToken',
      },
      body: jsonEncode({'product_ids': productIds}),
    );

    if (response.statusCode == 401) {
      final refreshSuccess = await refreshToken();
      if (!refreshSuccess) {
        return false;
      }

      jwtToken = await storage.read(key: 'jwtToken');
      response = await http.post(
        Uri.parse('$_baseUrl/shopping_lists/$listId/products/batch_delete'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwtToken',
        },
        body: jsonEncode({'product_ids': productIds}),
      );
    }

    return response.statusCode == 200;
  }

  Future<bool> changePassword(
      String currentPassword, String newPassword) async {
    final jwtToken = await storage.read(key: 'jwtToken');
    if (jwtToken == null) {
      return false;
    }

    final response = await http.post(
      Uri.parse('$_baseUrl/change_password'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwtToken',
      },
      body: jsonEncode({
        'current_password': currentPassword,
        'new_password': newPassword,
      }),
    );

    if (response.statusCode == 401) {
      final refreshSuccess = await refreshToken();
      if (!refreshSuccess) {
        return false;
      }
      return await changePassword(currentPassword, newPassword);
    }

    return response.statusCode == 200;
  }

  Future<bool> deleteAccount() async {
    final jwtToken = await storage.read(key: 'jwtToken');
    if (jwtToken == null) {
      return false;
    }

    final response = await http.delete(
      Uri.parse('$_baseUrl/delete_account'),
      headers: {
        'Authorization': 'Bearer $jwtToken',
      },
    );

    if (response.statusCode == 401) {
      final refreshSuccess = await refreshToken();
      if (!refreshSuccess) {
        return false;
      }
      return await deleteAccount();
    }

    if (response.statusCode == 200) {
      await storage.deleteAll();
      NavigationHelper.pushReplacementNamed(AppRoutes.login);
    }

    return response.statusCode == 200;
  }

  Future<Map<String, dynamic>?> getAccountInfo() async {
    String? jwtToken = await storage.read(key: 'jwtToken');
    if (jwtToken == null) {
      return null;
    }

    var response = await http.get(
      Uri.parse('$_baseUrl/account'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwtToken',
      },
    );

    if (response.statusCode == 401) {
      final refreshSuccess = await refreshToken();
      if (!refreshSuccess) {
        return null;
      }

      jwtToken = await storage.read(key: 'jwtToken');
      response = await http.get(
        Uri.parse('$_baseUrl/account'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwtToken',
        },
      );
    }

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    return null;
  }

  Future<bool> editUsername(String newUsername, String currentPassword) async {
    String? jwtToken = await storage.read(key: 'jwtToken');
    if (jwtToken == null) {
      return false;
    }

    var response = await http.post(
      Uri.parse('$_baseUrl/edit_username'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwtToken',
      },
      body: jsonEncode({
        'new_username': newUsername,
        'current_password': currentPassword,
      }),
    );

    if (response.statusCode == 401) {
      final refreshSuccess = await refreshToken();
      if (!refreshSuccess) {
        return false;
      }

      jwtToken = await storage.read(key: 'jwtToken');
      response = await http.post(
        Uri.parse('$_baseUrl/edit_username'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwtToken',
        },
        body: jsonEncode({
          'new_username': newUsername,
          'current_password': currentPassword,
        }),
      );
    }

    return response.statusCode == 200;
  }

  Future<bool> editEmail(String newEmail, String currentPassword) async {
    String? jwtToken = await storage.read(key: 'jwtToken');
    if (jwtToken == null) {
      return false;
    }

    var response = await http.post(
      Uri.parse('$_baseUrl/edit_email'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwtToken',
      },
      body: jsonEncode({
        'new_email': newEmail,
        'current_password': currentPassword,
      }),
    );

    if (response.statusCode == 401) {
      final refreshSuccess = await refreshToken();
      if (!refreshSuccess) {
        return false;
      }

      jwtToken = await storage.read(key: 'jwtToken');
      response = await http.post(
        Uri.parse('$_baseUrl/edit_email'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwtToken',
        },
        body: jsonEncode({
          'new_email': newEmail,
          'current_password': currentPassword,
        }),
      );
    }

    return response.statusCode == 200;
  }
}
