import 'package:audibrain/l10n/l10n.dart';
import 'package:audibrain/views/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // final FlutterLocalization localization = FlutterLocalization.instance;
  // @override
  // void initState() {
  //   //localization
  //   localization.init(
  //     mapLocales: [
  //       const MapLocale('en', AppLocale.en),
  //       const MapLocale('km', AppLocale.km),
  //       const MapLocale('ja', AppLocale.ja),
  //     ],
  //     initLanguageCode: 'en',
  //   );
  //   localization.onTranslatedLanguage = _onTranslatedLanguage;
  //   super.initState();
  // }

// // the setState function here is a must to add
//   void _onTranslatedLanguage(Locale? locale) {
//     setState(() {});
//   }
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
      child: MaterialApp(
        supportedLocales: L10n.all,
        locale: Locale('ur'),
        // localizationsDelegates: <LocalizationsDelegate<Object>>[
        //   GlobalM,

        // ],
        // supportedLocales: localization.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        theme: ThemeData(scaffoldBackgroundColor: Colors.white),
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      ),
    );
  }
}
