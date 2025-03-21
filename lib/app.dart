import 'package:audibrain/l10n/l10n.dart';
import 'package:audibrain/views/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static void setLocale(BuildContext context, Locale newLocale) {
    final _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.updateLocale(newLocale);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en'); // Default locale

  @override
  void initState() {
    super.initState();
    _loadLanguagePreference();
  }

  Future<void> _loadLanguagePreference() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedLanguage = prefs.getString('selectedLanguage');

    if (savedLanguage != null) {
      setState(() {
        _locale = Locale(savedLanguage);
      });
    }
  }

  void updateLocale(Locale newLocale) {
    setState(() {
      _locale = newLocale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        // Use builder only if needed to use library outside ScreenUtilInit context
        builder: (_, child) {
          return MaterialApp(
            supportedLocales: L10n.all,
            locale: _locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              scaffoldBackgroundColor: Colors.white,
            ),
            home: child,
          );
        },
        child: const SplashScreen(),
      ),
      // child: MaterialApp(
      //   supportedLocales: L10n.all,
      //   locale: _locale,
      //   localizationsDelegates: AppLocalizations.localizationsDelegates,
      //   theme: ThemeData(scaffoldBackgroundColor: Colors.white),
      //   debugShowCheckedModeBanner: false,
      //   home: const SplashScreen(),
      // ),
    );
  }
}
