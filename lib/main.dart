import 'package:app/l10n/app_localization.dart';
import 'package:app/screens/login_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:app/providers/language_provider.dart';
import 'package:app/providers/timezone_provider.dart';
import 'package:app/screens/loading_screen.dart';
import 'package:app/screens/main_page.dart'; 
import 'package:app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'utils/helpers/navigation_helper.dart';
import 'utils/helpers/snackbar_helper.dart';
import 'providers/theme_provider.dart';
import 'providers/shopping_list_provider.dart';
import 'values/app_strings.dart';
import 'routes.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  tz.initializeTimeZones();
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  LanguageProvider languageProvider = LanguageProvider();
  await languageProvider.loadSavedLanguage();

  runApp(ShoppyListApp(languageProvider: languageProvider));
}

class ShoppyListApp extends StatefulWidget {
  final LanguageProvider languageProvider;

  const ShoppyListApp({super.key, required this.languageProvider});

  @override
  ShoppyListAppState createState() => ShoppyListAppState();
}

class ShoppyListAppState extends State<ShoppyListApp> {
  final ApiService apiService = ApiService();
  late Future<bool> loginCheckFuture;

  @override
  void initState() {
    super.initState();
    loginCheckFuture = checkLoginStatus();
  }

  Future<bool> checkLoginStatus() async {
    final startTime = DateTime.now();
    final isValidToken = await apiService.validateToken();
    final endTime = DateTime.now();

    final timeDiff = endTime.difference(startTime);
    if (timeDiff < const Duration(seconds: 1)) {
      await Future.delayed(const Duration(seconds: 1) - timeDiff);
    }

    return isValidToken;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ShoppingListProvider()),
        ChangeNotifierProvider(create: (_) => TimezoneProvider()),
        ChangeNotifierProvider(create: (_) => widget.languageProvider),
      ],
      child: Consumer2<ThemeProvider, LanguageProvider>(
        builder: (context, themeProvider, languageProvider, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: AppStrings.loginAndRegister,
          theme: themeProvider.themeData,
          locale: Locale(languageProvider.currentLanguage, ''),
          scaffoldMessengerKey: SnackbarHelper.key,
          navigatorKey: NavigationHelper.key,
          onGenerateRoute: Routes.generateRoute,
          supportedLocales: const [
            Locale('en', ''),
            Locale('de', ''),
            Locale('fr', ''),
            Locale('it', ''),
            Locale('es', ''),
          ],
          localizationsDelegates: const [
            AppLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: FutureBuilder<bool>(
            future: loginCheckFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LoadingScreen();
              } else {
                if (snapshot.data == true) {
                  return const MainPage();
                } else {
                  return const LoginPage();
                }
              }
            },
          ),
        ),
      ),
    );
  }
}
