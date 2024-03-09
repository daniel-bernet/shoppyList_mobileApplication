import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../utils/helpers/navigation_helper.dart';
import '../utils/helpers/snackbar_helper.dart';
import '../values/app_strings.dart';
import '../values/app_routes.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  ApiService apiService = ApiService();

  void _logOut() async {
    NavigationHelper.pushReplacementNamed(AppRoutes.login);
    // DELETE JWT TOKEN HERE!!!!!!
  }

  void _deleteAccount() {}

  void _changePassword() {}

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text(AppStrings.darkMode),
            value: isDarkMode,
            onChanged: (bool value) {
              // Handle theme change.
            },
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
        ],
      ),
    );
  }
}
