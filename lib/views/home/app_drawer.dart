import 'package:audibrain/controllers/auth_controller.dart';
import 'package:audibrain/utils/colors.dart';
import 'package:audibrain/views/auth/signup_page.dart';
import 'package:audibrain/views/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyAppDrawer extends StatefulWidget {
  const MyAppDrawer({super.key});

  @override
  State<MyAppDrawer> createState() => _MyAppDrawerState();
}

class _MyAppDrawerState extends State<MyAppDrawer> {
  // User log out
  void _userLogOut() async {
    final AuthController authController = AuthController();
    await authController.signOutFromGoogle();

    var sharedPref = await SharedPreferences.getInstance();
    sharedPref.setBool(SplashScreenState.KEYLOGIN, false);

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignUpScreen()),
    );

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Successfully logged out!')));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Drawer(
        width: 250,
        shadowColor: Colors.grey,
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: AColors.primary.withOpacity(0.3),
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: Colors.white,
        child: ListView(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 30,
                ),
                ListTile(
                  leading: const Icon(Icons.account_circle),
                  title: const Text('Account'),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Settings'),
                  onTap: () {},
                ),
                const SizedBox(
                  height: 30,
                ),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: AColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: _userLogOut,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 60),
                      child: Text('Log Out'),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
