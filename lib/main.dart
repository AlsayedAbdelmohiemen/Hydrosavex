import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hydrosavex/controller/Onboarding_provider.dart';
import 'package:hydrosavex/controller/language_provider.dart';
import 'package:hydrosavex/controller/settings_provider.dart';
import 'package:hydrosavex/l10n/app_localizations.dart' show AppLocalizations;
import 'package:hydrosavex/utils/theme/theme.dart';
import 'package:hydrosavex/view/my_app.dart';
import 'package:hydrosavex/view/wiredash/wiredsh_app.dart';
import 'package:provider/provider.dart';
import 'package:hydrosavex/services/notification_service.dart';
import 'controller/timer_provider.dart';
import 'view/splash_screen/SplashScreenView.dart';
import 'view/onboarding_screen/widgets/Onboarding_page_view.dart';
import 'view/onboarding_screen/widgets/onboard_screen_item.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Firebase initialized before running the app
  await NotificationService().initialize(); // Initialize notification channel and sound listeners

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LanguagesProvider()),
        ChangeNotifierProvider(create: (_) => TimerProvider()),
        ChangeNotifierProvider(
            create: (_) =>
                OnboardingProvider()), // Ensure OnboardingProvider is added here
        ChangeNotifierProvider(
          create: (context) => SettingsProvider(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<SettingsProvider>(context);
    return Consumer<LanguagesProvider>(
      builder: (context, languageProvider, child) {
        return WiredashApp(
          navigatorKey: _navigatorKey,
          child: MaterialApp(
            title: 'HydroSaveX App',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: provider.themeMode,
            debugShowCheckedModeBanner: false,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: Locale(languageProvider.currentLanguage),
            initialRoute: SplashScreen.routeName,
            routes: {
              SplashScreen.routeName: (context) => const SplashScreen(),
              AuthStream.routeName: (context) => AuthStream(),
              OnboardingPageView.routeName: (context) => OnboardScreenItem(),
            },
          ),
        );
      },
    );
  }
}
