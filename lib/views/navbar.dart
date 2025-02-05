import 'package:audibrain/utils/colors.dart';
import 'package:audibrain/views/assistant/voice_assistant.dart';
import 'package:audibrain/views/history/history_page.dart';
import 'package:audibrain/views/home/homepage.dart';
import 'package:audibrain/views/profile/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int screenIndex = 0;
  @override
  Widget build(BuildContext context) {
    List screenList = [
      HomePage(),
      VoiceAssistantPage(),
      HistoryPage(),
      ProfilePage(),
    ];
    return Scaffold(
      bottomNavigationBar: ConvexAppBar(
        height: 65,
        backgroundColor: AColors.primary,
        items: const [
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.assistant, title: 'Assistant'),
          TabItem(icon: Icons.history, title: 'History'),
          TabItem(icon: Icons.account_circle, title: 'Profile'),
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
