import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../utils/helpers/navigation_helper.dart';
import '../values/app_strings.dart';
import '../values/app_routes.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final ApiService apiService = ApiService();
  Map<String, dynamic>? accountInfo;

  @override
  void initState() {
    super.initState();
    _fetchAccountInfo();
  }

  void _fetchAccountInfo() async {
    final info = await apiService.getAccountInfo();
    if (info != null) {
      setState(() {
        accountInfo = info;
      });
    }
  }

  void _logOut() async {
    await apiService.logOut();
    NavigationHelper.pushReplacementNamed(AppRoutes.login);
  }

  void _changeEmail() {
    // Placeholder for change email logic
  }

  void _changeUsername() {
    // Placeholder for change username logic
  }

  void _changePassword() {
    // Navigate to Change Password Page
  }

  void _deleteAccount() {
    // Navigate to Delete Account Confirmation Page
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: ListView(
        children: [
          if (accountInfo != null) ...[
            ListTile(
              title: const Text('Username'),
              subtitle: Text(accountInfo!['username'] ?? 'N/A'),
            ),
            ListTile(
              title: const Text('Email'),
              subtitle: Text(accountInfo!['email'] ?? 'N/A'),
            ),
            ListTile(
              title: const Text('Registered On'),
              subtitle: Text(accountInfo!['registered_on'] ?? 'N/A'),
            ),
          ],
          ListTile(
            trailing: const Icon(Icons.email),
            title: const Text(AppStrings.changeEmail),
            onTap: _changeEmail,
          ),
          ListTile(
            trailing: const Icon(Icons.person),
            title: const Text(AppStrings.changeUsername),
            onTap: _changeUsername,
          ),
          ListTile(
            trailing: const Icon(Icons.logout),
            title: const Text(AppStrings.logOut),
            onTap: _logOut,
          ),
          ListTile(
            trailing: const Icon(Icons.password),
            title: const Text(AppStrings.changePassword),
            onTap: _changePassword,
          ),
          ListTile(
            trailing: const Icon(Icons.delete),
            title: const Text(AppStrings.deleteAccount),
            onTap: _deleteAccount,
          ),
          SwitchListTile(
            title: const Text(AppStrings.darkMode),
            value: isDarkMode,
            onChanged: (bool value) {
              // Handle theme change.
            },
          ),
        ],
      ),
    );
  }
}
