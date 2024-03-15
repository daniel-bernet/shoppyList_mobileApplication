import 'package:app/providers/language_provider.dart';
import 'package:app/providers/timezone_provider.dart';
import 'package:app/utils/helpers/snackbar_helper.dart';
import 'package:app/providers/theme_provider.dart';
import 'package:app/values/app_regex.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../utils/helpers/navigation_helper.dart';
import '../values/app_strings.dart';
import '../values/app_routes.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/timezone_provider.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final ApiService apiService = ApiService();
  Map<String, dynamic>? accountInfo;
  String? selectedTimezone;

  final List<String> timezones = [
    'Pacific/Honolulu',
    'America/Anchorage',
    'America/Los_Angeles',
    'America/Denver',
    'America/Chicago',
    'America/New_York',
    'America/Argentina/Buenos_Aires',
    'Atlantic/Reykjavik',
    'Europe/London',
    'Europe/Berlin',
    'Europe/Athens',
    'Asia/Dubai',
    'Asia/Kolkata',
    'Asia/Shanghai',
    'Asia/Tokyo',
    'Australia/Sydney',
  ];

  @override
  void initState() {
    super.initState();
    _fetchAccountInfo();
    _loadTimezonePreference();
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
                      const SnackBar(
                          content: Text(AppStrings.emailChangedSuccess)),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(AppStrings.emailChangedFailure)),
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
        final TextEditingController newUsernameController =
            TextEditingController();
        final TextEditingController currentPasswordController =
            TextEditingController();
        final GlobalKey<FormState> formKey = GlobalKey<FormState>();

        return AlertDialog(
          title: const Text(AppStrings.changeUsername),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  controller: newUsernameController,
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
                  controller: currentPasswordController,
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
                if (formKey.currentState!.validate()) {
                  bool success = await apiService.editUsername(
                    newUsernameController.text.trim(),
                    currentPasswordController.text.trim(),
                  );

                  if (success) {
                    Navigator.of(context).pop();
                    _fetchAccountInfo();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(AppStrings.usernameChangedSuccess)),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
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
        final TextEditingController currentPasswordController =
            TextEditingController();
        final TextEditingController newPasswordController =
            TextEditingController();
        final TextEditingController confirmNewPasswordController =
            TextEditingController();
        final GlobalKey<FormState> formKey = GlobalKey<FormState>();

        return AlertDialog(
          title: const Text(AppStrings.changePassword),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  controller: currentPasswordController,
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
                  controller: newPasswordController,
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
                  controller: confirmNewPasswordController,
                  decoration:
                      const InputDecoration(hintText: "Confirm New Password"),
                  obscureText: true,
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value != newPasswordController.text) {
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
                if (formKey.currentState!.validate()) {
                  bool success = await apiService.changePassword(
                    currentPasswordController.text.trim(),
                    newPasswordController.text.trim(),
                  );

                  if (success) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(AppStrings.passwordChangedSuccess)),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
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

  Future<void> _loadTimezonePreference() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedTimezone = prefs.getString('selectedTimezone');
    final provider = Provider.of<TimezoneProvider>(context, listen: false);
    provider.setTimezone(savedTimezone ?? 'UTC');
  }

  Future<void> _saveTimezonePreference(String timezone) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedTimezone', timezone);
    final provider = Provider.of<TimezoneProvider>(context, listen: false);
    provider.setTimezone(timezone);
  }

  String _formatRegisteredOn(String? registeredOn, String timezone) {
    if (registeredOn == null) return 'N/A';

    final initialDate = DateTime.parse(registeredOn).toUtc();
    final location = tz.getLocation(timezone);
    final localDate = tz.TZDateTime.from(initialDate, location);

    return DateFormat('dd.MM.yyyy HH:mm').format(localDate);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final timezoneProvider = Provider.of<TimezoneProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    final availableLanguages = ['en', 'placeholder'];

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
              subtitle: Text(_formatRegisteredOn(
                  accountInfo?['registered_on'], timezoneProvider.timezone)),
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
          ListTile(
            title: const Text('Timezone'),
            trailing: DropdownButton<String>(
              value: selectedTimezone,
              onChanged: (String? newValue) async {
                setState(() {
                  selectedTimezone = newValue;
                  tz.setLocalLocation(tz.getLocation(newValue!));
                });
                await _saveTimezonePreference(newValue!);
              },
              items: timezones.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          ListTile(
            title: const Text('Language'),
            trailing: DropdownButton<String>(
              value: languageProvider.currentLanguage,
              onChanged: (String? newValue) {
                languageProvider.setLanguage(newValue!);
              },
              items: availableLanguages
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value.toUpperCase()),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
