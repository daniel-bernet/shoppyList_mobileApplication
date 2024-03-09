import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  final String _baseUrl = 'http://10.0.2.2:5000';
  final storage = const FlutterSecureStorage();

  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final jwtToken = jsonDecode(response.body)['access_token'];
      await storage.write(key: 'jwtToken', value: jwtToken);
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
      final jwtToken = jsonDecode(response.body)['access_token'];
      await storage.write(key: 'jwtToken', value: jwtToken);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> validateToken() async {
    final jwtToken = await storage.read(key: 'jwtToken');
    if (jwtToken == null) {
      return false;
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/validate-token'),
      headers: {
        'Authorization': 'Bearer $jwtToken',
      },
    );

    return response.statusCode == 200;
  }

  Future<void> logOut() async {
    await storage.deleteAll();
  }

  Future<bool> createShoppingList(String title) async {
    final jwtToken = await storage.read(key: 'jwtToken');
    if (jwtToken == null) {
      return false;
    }

    final response = await http.post(
      Uri.parse('$_baseUrl/shopping_lists'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwtToken',
      },
      body: jsonEncode({'title': title}),
    );

    return response.statusCode == 201;
  }
}
