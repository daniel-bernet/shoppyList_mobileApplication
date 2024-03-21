import 'package:app/components/password_field.dart';
import 'package:app/l10n/app_localization.dart';
import 'package:app/screens/main_page.dart';
import 'package:app/services/api_service.dart';
import 'package:app/utils/helpers/snackbar_helper.dart';
import 'package:app/values/app_routes.dart';
import 'package:flutter/material.dart';
import '../utils/common_widgets/gradient_background.dart';
import '../utils/helpers/navigation_helper.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      final success = await apiService.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (!mounted) return;

      if (success) {
        SnackbarHelper.showSnackBar(
            AppLocalizations.of(context).translate('loggedIn'));
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const MainPage(),
        ));
      } else {
        SnackbarHelper.showSnackBar(
            AppLocalizations.of(context).translate('loginFailed'),
            isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          GradientBackground(
            children: [
              Text(
                appLocalizations.translate('login'),
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                appLocalizations.translate('signInToYourAccount'),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.surface,
                ),
              ),
            ],
          ),
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: appLocalizations.translate('email'),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: (value) => value!.isEmpty
                        ? appLocalizations.translate('pleaseEnterEmailAddress')
                        : null,
                  ),
                  const SizedBox(height: 20),
                  PasswordField(
                    controller: passwordController,
                    labelText: appLocalizations.translate('password'),
                    validator: (value) => value!.isEmpty
                        ? appLocalizations.translate('pleaseEnterPassword')
                        : null,
                    textInputAction: TextInputAction.done,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _login,
                    child: Text(appLocalizations.translate('login')),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                appLocalizations.translate('doNotHaveAnAccount'),
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(width: 4),
              TextButton(
                onPressed: () => NavigationHelper.pushReplacementNamed(AppRoutes.register),
                child: Text(appLocalizations.translate('register')),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
