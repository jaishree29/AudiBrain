import 'package:audibrain/app.dart';
import 'package:audibrain/controllers/auth_controller.dart';
import 'package:audibrain/utils/colors.dart';
import 'package:audibrain/views/auth/login_page.dart';
import 'package:audibrain/views/navbar.dart';
import 'package:audibrain/views/pwd_navbar.dart';
import 'package:audibrain/widgets/elevated_button.dart';
import 'package:audibrain/widgets/text_field_input.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthController _authController = AuthController();
  String? _selectedRole;
  String? _selectedLanguageCode; // Stores only the language code

  // Mapping of language codes to names
  final Map<String, String> _languageMap = {
    'en': 'English',
    'as': 'Assamese',
    'bn': 'Bengali',
    'hi': 'Hindi',
    'gu': 'Gujarati',
    'ka': 'Kannada',
    'kn': 'Kashmiri',
    'ko': 'Konkani',
    'ml': 'Malayalam',
    'mr': 'Marathi',
    'or': 'Oriya',
    'pa': 'Punjabi',
    'ta': 'Tamil',
    'te': 'Telugu',
    'ur': 'Urdu',
    'bo': 'Bodo',
    'sat': 'Santhali',
    'dog': 'Dogri',
  };

  @override
  void initState() {
    super.initState();
    _loadSelectedLanguage();
  }

  Future<void> _loadSelectedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLanguageCode =
          prefs.getString('selectedLanguage') ?? 'en'; // Default to English
    });
  }

  Future<void> _setSelectedLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedLanguage', languageCode);
    setState(() {
      _selectedLanguageCode = languageCode;
    });

    MyApp.setLocale(context, Locale(languageCode));
  }

  void _handleSignUp() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final prefs = await SharedPreferences.getInstance();

    if (email.isEmpty ||
        password.isEmpty ||
        _selectedRole == null ||
        _selectedLanguageCode == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields.")),
      );
      return;
    }

    await prefs.setString('userRole', _selectedRole!);
    print('User role selected: $_selectedRole');

    final user = await _authController.signUpWithEmailPassword(
      email,
      password,
      _selectedRole!,
      _selectedLanguageCode!,
    );

    await _setSelectedLanguage(_selectedLanguageCode!);

    if (!mounted) return;

    if (user != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("User signed up: ${user.email}")),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              _selectedRole == 'pwd' ? const PwdNavbar() : const NavBar(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User already exists")),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                // App Name
                const Text(
                  'AudiBrain',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AColors.primary,
                  ),
                ),
                const SizedBox(height: 40),
                // Role Selection
                const Text(
                  'Sign up as:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Assisted User Role
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedRole = 'pwd';
                        });
                        print(_selectedRole);
                      },
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: _selectedRole == 'pwd'
                              ? AColors.primary
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.accessibility_new,
                              size: 40,
                              color: _selectedRole == 'pwd'
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Assisted User',
                              style: TextStyle(
                                fontFamily: 'Canva Sans',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: _selectedRole == 'pwd'
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'for those with speech disabilities',
                              style: TextStyle(
                                fontFamily: 'Canva Sans',
                                fontSize: 12,
                                color: _selectedRole == 'pwd'
                                    ? Colors.white
                                    : Colors.grey[600],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Regular User Role
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedRole = 'user';
                        });
                        print(_selectedRole);
                      },
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: _selectedRole == 'user'
                              ? AColors.primary
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.person,
                              size: 40,
                              color: _selectedRole == 'user'
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Regular User',
                              style: TextStyle(
                                color: _selectedRole == 'user'
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'for communicating with them',
                              style: TextStyle(
                                fontFamily: 'Canva Sans',
                                fontSize: 12,
                                color: _selectedRole == 'user'
                                    ? Colors.white
                                    : Colors.grey[600],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                // Email TextField
                ATextFieldInput(
                  hintText: 'Email',
                  icon: Icons.email,
                  isPass: false,
                  textController: _emailController,
                ),
                const SizedBox(height: 10),
                // Password TextField
                ATextFieldInput(
                  hintText: 'Password',
                  icon: Icons.lock,
                  isPass: true,
                  textController: _passwordController,
                ),
                const SizedBox(height: 30),
                // Language Selection Dropdown
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: DropdownButtonFormField<String>(
                    value: _selectedLanguageCode,
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        _setSelectedLanguage(newValue);
                      }
                    },
                    items: _languageMap.entries
                        .map<DropdownMenuItem<String>>((entry) {
                      return DropdownMenuItem<String>(
                        value: entry.key, // Stores the language code
                        child: Text(
                          entry.value,
                        ), // Displays the full language name
                      );
                    }).toList(),
                    decoration: const InputDecoration(
                      labelText: 'Select Language',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                // Sign-Up Button
                AElevatedButton(
                  text: 'Sign Up',
                  onPressed: _handleSignUp,
                  backgroundColor: AColors.primary,
                ),
                const SizedBox(height: 20),
                // Sign-In Option
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account?',
                      style: TextStyle(fontSize: 16),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignInScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Sign In',
                        style: TextStyle(
                          fontFamily: 'Canva Sans',
                          fontSize: 16,
                          color: AColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
