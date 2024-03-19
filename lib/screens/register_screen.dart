import 'package:app/l10n/app_localization.dart';
import 'package:app/utils/helpers/snackbar_helper.dart';
import 'package:app/services/api_service.dart';
import 'package:app/values/app_constants.dart';
import 'package:app/values/app_routes.dart';
import 'package:flutter/material.dart';
import '../utils/common_widgets/gradient_background.dart';
import '../utils/helpers/navigation_helper.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final TextEditingController confirmPasswordController;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _register() async {
    if (_formKey.currentState!.validate()) {
      final success = await apiService.register(
        nameController.text.trim(),
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (!mounted) return null;

      if (success) {
        SnackbarHelper.showSnackBar(
            AppLocalizations.of(context).translate('registrationComplete'));
        NavigationHelper.pushReplacementNamed(AppRoutes.main);
      } else {
        SnackbarHelper.showSnackBar(
            AppLocalizations.of(context).translate('registrationFailed'),
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
                appLocalizations.translate('register'),
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                appLocalizations.translate('createYourAccount'),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: appLocalizations.translate('name'),
                    ),
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: appLocalizations.translate('email'),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (!AppConstants.emailRegex.hasMatch(value ?? "")) {
                        return appLocalizations.translate('emailRequirements');
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: appLocalizations.translate('password'),
                    ),
                    obscureText: true,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (!AppConstants.passwordRegex.hasMatch(value ?? "")) {
                        return appLocalizations
                            .translate('passwordRequirements');
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: appLocalizations.translate('confirmPassword'),
                    ),
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      if (value != passwordController.text) {
                        return appLocalizations.translate('passwordNotMatched');
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _register,
                    child: Text(appLocalizations.translate('register')),
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                appLocalizations.translate('iHaveAnAccount'),
                style: theme.textTheme.bodySmall,
              ),
              TextButton(
                onPressed: () => NavigationHelper.pushReplacementNamed(AppRoutes.login),
                child: Text(appLocalizations.translate('login')),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
