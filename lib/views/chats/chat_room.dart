import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({super.key, required this.userMap, required this.chatRoomId});

  final Map<String, dynamic> userMap;
  final String chatRoomId;

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final TextEditingController _message = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void sendMessage() async {
    String? currentUserEmail = _auth.currentUser?.email;

    if (_message.text.trim().isNotEmpty && currentUserEmail != null) {
      Map<String, dynamic> messageData = {
        "message": _message.text.trim(),
        "sender": currentUserEmail,
        "time": FieldValue.serverTimestamp(),
      };

      await _firestore
          .collection('chatrooms')
          .doc(widget.chatRoomId)
          .collection('messages')
          .add(messageData);

      _message.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    String? currentUserEmail = _auth.currentUser?.email;

    return Scaffold(
      appBar: AppBar(title: Text(widget.userMap['email'])),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('chatrooms')
                  .doc(widget.chatRoomId)
                  .collection('messages')
                  .orderBy('time', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No messages yet"));
                }

                return ListView.builder(
                  reverse: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var messageData = snapshot.data!.docs[index].data()
                        as Map<String, dynamic>;
                    bool isSentByMe = messageData['sender'] == currentUserEmail;

                    return Align(
                      alignment: isSentByMe
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.symmetric(
                            vertical: 5.sp, horizontal: 10.sp),
                        padding: EdgeInsets.all(10.sp),
                        decoration: BoxDecoration(
                          color: isSentByMe
                              ? Colors.blueAccent
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          messageData['message'],
                          style: TextStyle(
                              color: isSentByMe ? Colors.white : Colors.black),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.sp),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _message,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: 'Send Message',
                    ),
                  ),
                ),
                IconButton(
                  onPressed: sendMessage,
                  icon: const Icon(Icons.send_rounded, color: Colors.blue),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
