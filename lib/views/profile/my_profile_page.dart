import 'package:audibrain/controllers/auth_controller.dart';
import 'package:audibrain/views/auth/signup_page.dart';
import 'package:audibrain/views/profile/edit_profile.dart';
import 'package:audibrain/views/profile/profile_card.dart';
import 'package:audibrain/views/splash_screen.dart';
import 'package:audibrain/widgets/elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthController _authController = AuthController();

  void _userLogOut() async {
    final AuthController authController = AuthController();

    try {
      await authController.signOutFromGoogle();

      var sharedPref = await SharedPreferences.getInstance();
      sharedPref.setBool(SplashScreenState.KEYLOGIN, false);
      await sharedPref.clear();

      print("Cleared the following data: \n ${sharedPref.toString()}");

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignUpScreen()),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Successfully logged out!')),
      );
    } catch (e) {
      print("Logout Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to log out. Please try again.')),
      );
    }
  }

  // User Log out
  // void _userLogOut() async {
  //   await _authController.signOutFromGoogle();

  //   var sharedPref = await SharedPreferences.getInstance();
  //   sharedPref.setBool(SplashScreenState.KEYLOGIN, false);

  //   if (!mounted) return;

  //   Navigator.pushReplacement(
  //     context,
  //     MaterialPageRoute(builder: (context) => const SignUpScreen()),
  //   );

  //   ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Successfully logged out!')));
  // }

  // Show dialog to enter email for password reset
  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String email = '';
        return AlertDialog(
          title: const Text('Change Password'),
          content: TextField(
            onChanged: (value) {
              email = value;
            },
            decoration: const InputDecoration(hintText: 'Enter your email'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await _authController.sendPasswordResetEmail(email);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Password reset email sent')),
                  );
                  Navigator.of(context).pop();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              },
              child: const Text('Send'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 185, // Height of the sticky header
              flexibleSpace: FlexibleSpaceBar(
                background: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 50),
                      const Padding(
                        padding: EdgeInsets.only(left: 4.0),
                        child: Text(
                          "Account Details",
                          style: TextStyle(
                              fontSize: 27, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 4.0),
                        child: Text(
                          "Update your settings like notifications,\nprofile edit etc.",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              pinned: false,
              backgroundColor: Colors.white,
              elevation: 4,
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          ProfileCard(
                            title: "Profile Information",
                            subtitle: "Change your account info",
                            icon: Icons.person,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditProfile()),
                              );
                            },
                          ),
                          ProfileCard(
                            title: "Change Password",
                            subtitle: "Change your password",
                            icon: Icons.lock,
                            onTap: _showChangePasswordDialog,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 25.0, top: 10),
                    child: Text("More", style: TextStyle(fontSize: 19)),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 20),
                    child: Column(
                      children: [
                        ProfileCard(
                          title: "Rate Us",
                          subtitle: "Rate us on Playstore, Appstore",
                          icon: Icons.star,
                          onTap: () {},
                        ),
                        ProfileCard(
                          title: "About Us",
                          subtitle: "Frequently asked questions",
                          icon: Icons.book,
                          onTap: () {},
                        ),
                        ProfileCard(
                            title: "Feedback",
                            subtitle: "Frequently asked questions",
                            icon: Icons.book,
                            onTap: () {}),
                        ProfileCard(
                          title: "Privacy",
                          subtitle: "Frequently asked questions",
                          icon: Icons.book,
                          onTap: () {},
                        ),
                        ProfileCard(
                          onTap: () {},
                          title: "Terms and Conditions",
                          subtitle: "Click to view",
                          icon: Icons.book,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: AElevatedButton(
                            text: 'Log out',
                            onPressed: _userLogOut,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
