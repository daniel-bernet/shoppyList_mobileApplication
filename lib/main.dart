import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'utils/helpers/navigation_helper.dart';
import 'utils/helpers/snackbar_helper.dart';
import 'utils/theme/theme_provider.dart';
import 'values/app_routes.dart';
import 'values/app_strings.dart';
import 'routes.dart';
import 'utils/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light),
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (_) => runApp(
      ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        child: const ShoppyListApp(),
      ),
    ),
  );
}

class ShoppyListApp extends StatelessWidget {
  const ShoppyListApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppStrings.loginAndRegister,
      theme: themeProvider.themeData,
      initialRoute: AppRoutes.login,
      scaffoldMessengerKey: SnackbarHelper.key,
      navigatorKey: NavigationHelper.key,
      onGenerateRoute: Routes.generateRoute,
    );
  }
}
