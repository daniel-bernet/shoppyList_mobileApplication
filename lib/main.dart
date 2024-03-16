import 'package:app/l10n/app_localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:app/providers/language_provider.dart';
import 'package:app/providers/timezone_provider.dart';
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
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  tz.initializeTimeZones();
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  LanguageProvider languageProvider = LanguageProvider();
  await languageProvider.loadSavedLanguage();

  runApp(ShoppyListApp(languageProvider: languageProvider));
}

class ShoppyListApp extends StatelessWidget {
  final LanguageProvider languageProvider;

  const ShoppyListApp({super.key, required this.languageProvider});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ShoppingListProvider()),
        ChangeNotifierProvider(create: (_) => TimezoneProvider()),
        ChangeNotifierProvider(create: (_) => languageProvider),
      ],
      child: Consumer2<ThemeProvider, LanguageProvider>(
        builder: (context, themeProvider, languageProvider, child) =>
            MaterialApp(
          debugShowCheckedModeBanner: false,
          title: AppStrings.loginAndRegister,
          theme: themeProvider.themeData,
          locale: Locale(languageProvider.currentLanguage, ''),
          initialRoute: AppRoutes.login,
          scaffoldMessengerKey: SnackbarHelper.key,
          navigatorKey: NavigationHelper.key,
          onGenerateRoute: Routes.generateRoute,
          supportedLocales: const [
            Locale('en', ''),
            Locale('de', ''),
          ],
          localizationsDelegates: const [
            AppLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          localeResolutionCallback: (locale, supportedLocales) {
            for (var supportedLocale in supportedLocales) {
              if (supportedLocale.languageCode == locale?.languageCode &&
                  supportedLocale.countryCode == locale?.countryCode) {
                return supportedLocale;
              }
            }
            return supportedLocales.first;
          },
        ),
      ),
    );
  }
}
