import 'package:audibrain/views/chats/display_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserChatPage extends StatefulWidget {
  final String name;
  const UserChatPage({
    super.key,
    this.name = 'regular.user@gmail.com',
  });

  @override
  State<UserChatPage> createState() => _UserChatPageState();
}

class _UserChatPageState extends State<UserChatPage> {
  //Controllers
  final TextEditingController messageController = TextEditingController();
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    print(widget.name);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.name,
          style: TextStyle(
            fontFamily: 'Canva Sans',
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                child: DisplayMessage(),
              ),
              Padding(
                padding: EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: messageController,
                        decoration: InputDecoration(
                          filled: true,
                          hintText: "Message",
                          enabled: true,
                          contentPadding: EdgeInsets.only(
                            left: 15,
                            bottom: 8,
                            top: 8,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.green,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        validator: (value) {
                          return null;
                        },
                        onSaved: (value) {
                          messageController.text = value!;
                        },
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (messageController.text.isNotEmpty) {
                          firebaseFirestore.collection('Message').doc().set(
                            {
                              'message': messageController.text.trim(),
                              'time': DateTime.now(),
                              'name': widget.name,
                            },
                          );
                          messageController.clear();
                        }
                      },
                      icon: Icon(Icons.send),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
