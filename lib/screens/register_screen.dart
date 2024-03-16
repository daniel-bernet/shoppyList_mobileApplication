import 'package:app/l10n/app_localization.dart';
import 'package:app/screens/main_page.dart';
import 'package:app/utils/helpers/snackbar_helper.dart';
import 'package:app/services/api_service.dart';
import 'package:app/values/app_routes.dart';
import 'package:flutter/material.dart';
import '../components/app_text_form_field.dart';
import '../utils/common_widgets/gradient_background.dart';
import '../utils/helpers/navigation_helper.dart';
import '../utils/theme/app_theme.dart';

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

      if (success && mounted) {
        SnackbarHelper.showSnackBar(AppLocalizations.of(context).translate('registrationComplete'));
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const MainPage(),
        ));
      } else {
        if (mounted) SnackbarHelper.showSnackBar(AppLocalizations.of(context).translate('registrationFailed'), isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);
    return Scaffold(
      body: ListView(
        children: [
          GradientBackground(
            children: [
              Text(appLocalizations.translate('register'),
                  style: AppTheme.lightTheme.textTheme.titleLarge),
              const SizedBox(height: 6),
              Text(appLocalizations.translate('createYourAccount'),
                  style: AppTheme.lightTheme.textTheme.bodySmall),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AppTextFormField(
                    labelText: appLocalizations.translate('name'),
                    controller: nameController,
                    textInputAction: TextInputAction.next, keyboardType: TextInputType.name,
                  ),
                  AppTextFormField(
                    labelText: appLocalizations.translate('email'),
                    controller: emailController,
                    textInputAction: TextInputAction.next, keyboardType: TextInputType.emailAddress,
                  ),
                  AppTextFormField(
                    labelText: appLocalizations.translate('password'),
                    controller: passwordController,
                    obscureText: true,
                    textInputAction: TextInputAction.next, keyboardType: TextInputType.name,
                  ),
                  AppTextFormField(
                    labelText: appLocalizations.translate('confirmPassword'),
                    controller: confirmPasswordController,
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      if (value != passwordController.text) {
                        return appLocalizations.translate('passwordNotMatched');
                      }
                      return null;
                    }, keyboardType: TextInputType.name,
                  ),
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
                style: AppTheme.lightTheme.textTheme.bodySmall,
              ),
              TextButton(
                onPressed: () {
                  NavigationHelper.pushReplacementNamed(AppRoutes.login);
                },
                child: Text(appLocalizations.translate('login')),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
