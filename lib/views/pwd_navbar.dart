import 'package:audibrain/utils/colors.dart';
import 'package:audibrain/views/chats/chats_page.dart';
import 'package:audibrain/views/home/homepage.dart';
import 'package:audibrain/views/profile/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

class PwdNavbar extends StatefulWidget {
  const PwdNavbar({super.key});

  @override
  State<PwdNavbar> createState() => _PwdNavbarState();
}

class _PwdNavbarState extends State<PwdNavbar> {
  int screenIndex = 0;
  @override
  Widget build(BuildContext context) {
    List screenList = [
      HomePage(),
      ChatsPage(),
      ProfilePage(),
    ];
    return Scaffold(
      bottomNavigationBar: ConvexAppBar(
        height: 65,
        backgroundColor: AColors.primary,
        items: const [
          TabItem(
            icon: Icons.home,
            title: 'Home',
          ),
          TabItem(
            icon: Icons.chat,
            title: 'Chats',
          ),
          TabItem(
            icon: Icons.account_circle,
            title: 'Profile',
          ),
        ],
        onTap: (int i) {
          setState(() {
            screenIndex = i;
          });
        },
      ),
      body: screenList[screenIndex],
    );
  }
}
