import 'package:audibrain/utils/colors.dart';
import 'package:audibrain/views/chats/chat_page.dart';
import 'package:flutter/material.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AColors.primary,
        foregroundColor: Colors.white,
        title: Text(
          'Chats',
          style: TextStyle(
            fontFamily: 'Canva Sans',
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(
                  name: 'regular.user@gmail.com',
                ),
              ),
            );
          },
          child: Text('Open chat page'),
        ),
      ),
    );
  }
}
