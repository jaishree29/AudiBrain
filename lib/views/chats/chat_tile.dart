import 'package:flutter/material.dart';

class ChatTile extends StatelessWidget {
  const ChatTile({
    super.key,
    required this.email,
    required this.role,
    required this.userId,
    required this.onTap,
    this.latestMessage, 
  });

  final String email;
  final String role;
  final String userId;
  final Function onTap;
  final String? latestMessage;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        onTap: () => onTap.call(),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        title: Text(
          email,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              role,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[600],
              ),
            ),
            if (latestMessage != null) 
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  latestMessage!,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis, 
                ),
              ),
          ],
        ),
      ),
    );
  }
}
