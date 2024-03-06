import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final user = FirebaseAuth.instance.currentUser;

  void _logOut() async {
    await FirebaseAuth.instance.signOut();
    NavigationHelper.pushReplacementNamed(AppRoutes.login);
  }

  void _deleteAccount() async {
    try {
      await user?.delete();
      NavigationHelper.pushReplacementNamed(AppRoutes.login);
    } on FirebaseAuthException catch (e) {
      SnackbarHelper.showSnackBar(e.message ?? AppStrings.errorOccurred, isError: true);
    }
  }

  void _changePassword() {
    // Here, implement functionality to allow users to change their password.
    // For simplicity, you could navigate to a dedicated ChangePasswordPage or show a dialog to enter a new password.
  }

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
              // This should toggle the theme in your app state, which could be managed with Provider, Riverpod, or similar.
              // For now, just reflect a basic UI response.
              // You'd typically trigger a theme change in your app's state management from here.
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
