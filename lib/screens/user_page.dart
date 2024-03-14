import 'package:app/utils/helpers/snackbar_helper.dart';
import 'package:app/utils/theme/theme_provider.dart';
import 'package:app/values/app_regex.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    final confirmLogout = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Log Out'),
          content: const Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Log Out'),
            ),
          ],
        );
      },
    );

    if (confirmLogout == true) {
      await apiService.logOut();
    }
  }

  void _changeEmail() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController _newEmailController =
            TextEditingController();
        final TextEditingController _currentPasswordController =
            TextEditingController();
        final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

        return AlertDialog(
          title: const Text(AppStrings.changeEmail),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  controller: _newEmailController,
                  decoration: const InputDecoration(hintText: "New Email"),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        !value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _currentPasswordController,
                  decoration:
                      const InputDecoration(hintText: "Current Password"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your current password';
                    }
                    return null;
                  },
                  obscureText: true,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(AppStrings.cancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(AppStrings.submit),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  bool success = await apiService.editEmail(
                    _newEmailController.text.trim(),
                    _currentPasswordController.text.trim(),
                  );

                  if (success) {
                    Navigator.of(context).pop();
                    _fetchAccountInfo(); // Refresh account information
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(AppStrings.emailChangedSuccess)),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(AppStrings.emailChangedFailure)),
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _changeUsername() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController _newUsernameController =
            TextEditingController();
        final TextEditingController _currentPasswordController =
            TextEditingController();
        final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

        return AlertDialog(
          title: const Text(AppStrings.changeUsername),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  controller: _newUsernameController,
                  decoration: const InputDecoration(hintText: "New Username"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a valid username';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _currentPasswordController,
                  decoration:
                      const InputDecoration(hintText: "Current Password"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your current password';
                    }
                    return null;
                  },
                  obscureText: true,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(AppStrings.cancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(AppStrings.submit),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  bool success = await apiService.editUsername(
                    _newUsernameController.text.trim(),
                    _currentPasswordController.text.trim(),
                  );

                  if (success) {
                    Navigator.of(context).pop();
                    _fetchAccountInfo(); // Refresh account information
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(AppStrings.usernameChangedSuccess)),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(AppStrings.usernameChangedFailure)),
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _changePassword() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController _currentPasswordController =
            TextEditingController();
        final TextEditingController _newPasswordController =
            TextEditingController();
        final TextEditingController _confirmNewPasswordController =
            TextEditingController();
        final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

        return AlertDialog(
          title: const Text(AppStrings.changePassword),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  controller: _currentPasswordController,
                  decoration:
                      const InputDecoration(hintText: "Current Password"),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your current password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _newPasswordController,
                  decoration: const InputDecoration(hintText: "New Password"),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your new password';
                    }
                    if (!AppRegex.passwordRegex.hasMatch(value)) {
                      return 'Your password does not meet the requirements';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _confirmNewPasswordController,
                  decoration:
                      const InputDecoration(hintText: "Confirm New Password"),
                  obscureText: true,
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value != _newPasswordController.text) {
                      return 'The password confirmation does not match';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(AppStrings.cancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(AppStrings.submit),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  bool success = await apiService.changePassword(
                    _currentPasswordController.text.trim(),
                    _newPasswordController.text.trim(),
                  );

                  if (success) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(AppStrings.passwordChangedSuccess)),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(AppStrings.passwordChangedFailure)),
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteAccount() async {
    final confirmDeletion = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Account'),
          content: const Text(
              'Are you sure you want to delete your account? This action cannot be undone\n\nAll information, lists and products associated with this account will be removed.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (confirmDeletion == true) {
      final success = await apiService.deleteAccount();
      if (success) {
        SnackbarHelper.showSnackBar('Account deleted successfully.');
        NavigationHelper.pushReplacementNamed(AppRoutes.login);
      } else {
        SnackbarHelper.showSnackBar('Failed to delete account.', isError: true);
      }
    }
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
              final themeProvider =
                  Provider.of<ThemeProvider>(context, listen: false);
              themeProvider.toggleTheme();
            },
          ),
        ],
      ),
    );
  }
}
