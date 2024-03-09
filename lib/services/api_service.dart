import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Add this dependency for secure storage

class ApiService {
  final String _baseUrl = 'http://10.0.2.2:5000'; // Use this for local testing
  // For deployment, replace the above line with the IP or domain of your deployed API
  // final String _baseUrl = 'https://yourapi.com';
  final storage = FlutterSecureStorage(); // Instantiate FlutterSecureStorage

  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      // Store JWT token using FlutterSecureStorage
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
      // Optionally handle registration-specific JWT token logic here
      return true;
    } else {
      return false;
    }
  }

  // Method to retrieve stored JWT token
  Future<String?> getJwtToken() async {
    return await storage.read(key: 'jwtToken');
  }

  // Example method to perform authenticated requests
  Future<void> getProtectedData() async {
    final jwtToken = await getJwtToken();
    final response = await http.get(
      Uri.parse('$_baseUrl/protected-route'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwtToken',
      },
    );

    if (response.statusCode == 200) {
      // Process your protected data
    } else {
      // Handle errors or token expiration
    }
  }
}
