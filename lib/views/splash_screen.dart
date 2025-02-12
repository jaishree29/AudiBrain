import 'dart:async';
import 'package:audibrain/utils/colors.dart';
import 'package:audibrain/views/auth/signup_page.dart';
import 'package:audibrain/views/navbar.dart';
import 'package:audibrain/views/pwd_navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  static const String KEYLOGIN = 'Login';
  @override
  void initState() {
    super.initState();
    whereToGo();
  }

  void whereToGo() async {
    var sharedPref = await SharedPreferences.getInstance();
    var isLoggedIn = sharedPref.getBool(KEYLOGIN);
    var role = sharedPref.getString('userRole');

    print("Splash Screen: isLoggedIn = $isLoggedIn, role = $role");

    Timer(const Duration(seconds: 3), () {
      if (isLoggedIn == true) {
        if (role == 'pwd') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const PwdNavbar()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const NavBar()),
          );
        }
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignUpScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AColors.primary,
      body: Center(
        child: Text(
          AppLocalizations.of(context)!.appName,
          style: TextStyle(
            fontSize: 50,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.normal,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
