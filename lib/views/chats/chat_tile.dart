import 'package:flutter/material.dart';

class ChatTile extends StatelessWidget {
  const ChatTile({
    super.key,
    required this.email,
    required this.role,
    required this.userId,
  });

  final String email;
  final String role;
  final String userId;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 0,
        ),
        title: Text(
          email,
          style: TextStyle(fontSize: 17),
        ),
        subtitle: Text(
          role,
          style: TextStyle(fontSize: 15),
        ),
      ),
    );
  }
}
