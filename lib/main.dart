import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'utils/helpers/navigation_helper.dart';
import 'utils/helpers/snackbar_helper.dart';
import 'providers/theme_provider.dart';
import 'providers/shopping_list_provider.dart';
import 'values/app_routes.dart';
import 'values/app_strings.dart';
import 'routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light),
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (_) => runApp(const ShoppyListApp()),
  );
}

class ShoppyListApp extends StatelessWidget {
  const ShoppyListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ShoppingListProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: AppStrings.loginAndRegister,
          theme: themeProvider.themeData,
          initialRoute: AppRoutes.login,
          scaffoldMessengerKey: SnackbarHelper.key,
          navigatorKey: NavigationHelper.key,
          onGenerateRoute: Routes.generateRoute,
        ),
      ),
    );
  }
}
