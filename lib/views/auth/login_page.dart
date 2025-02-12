import 'package:audibrain/app.dart';
import 'package:audibrain/controllers/auth_controller.dart';
import 'package:audibrain/utils/colors.dart';
import 'package:audibrain/views/auth/signup_page.dart';
import 'package:audibrain/views/navbar.dart';
import 'package:audibrain/views/pwd_navbar.dart';
import 'package:audibrain/views/splash_screen.dart';
import 'package:audibrain/widgets/elevated_button.dart';
import 'package:audibrain/widgets/text_field_input.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthController _authController = AuthController();

  Future<void> setAppLanguage(String langCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedLanguage', langCode);

    if (!mounted) return;

    MyApp.setLocale(context, Locale(langCode)); // Update UI
  }

  // Sign-In with Email and Password
  void _handleSignIn() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields.")),
      );
      return;
    }

    try {
      final user =
          await _authController.signInWithEmailPassword(email, password);

      if (!mounted) return;

      if (user != null) {
        var sharedPref = await SharedPreferences.getInstance();
        await sharedPref.setBool(SplashScreenState.KEYLOGIN, true);
        sharedPref.setString('userRole', user.role ?? 'user');
        sharedPref.setString('selectedLanguage', user.language ?? 'en');

        print("Role: ${user.role}");
        print("Language: ${user.language}");

        await setAppLanguage(
          user.language ?? 'en',
        ); // Ensure language changes before navigation

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Welcome back, ${user.email}!")),
        );

        // Navigate based on role
        if (user.role == 'pwd') {
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("User does not exist. Please sign up first.")),
        );
      }
    } catch (e) {
      print("Sign-in error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to sign in: ${e.toString()}")),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 100),
              const Icon(Icons.mail, size: 70),
              const SizedBox(height: 80),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ATextFieldInput(
                  hintText: 'Email',
                  icon: Icons.email,
                  isPass: false,
                  textController: _emailController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ATextFieldInput(
                  hintText: 'Password',
                  icon: Icons.lock,
                  isPass: true,
                  textController: _passwordController,
                ),
              ),
              const SizedBox(height: 80),
              AElevatedButton(
                text: 'Sign In',
                onPressed: _handleSignIn,
                backgroundColor: AColors.primary,
              ),
              const SizedBox(height: 50),
              Text(
                'Don\'t have an account?',
                style: TextStyle(fontSize: 17),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignUpScreen(),
                    ),
                  );
                },
                child: const Text('Sign Up', style: TextStyle(fontSize: 17)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
