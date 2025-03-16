import 'package:audibrain/utils/colors.dart';
import 'package:audibrain/views/chats/chat_room.dart';
import 'package:audibrain/views/chats/chat_tile.dart';
import 'package:audibrain/widgets/text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  final TextEditingController _searchController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isLoading = false;
  bool hasSearched = false;
  Map<String, dynamic>? userMap;
  String? currentUserEmail;

  @override
  void initState() {
    super.initState();
    currentUserEmail = _auth.currentUser?.email;
  }

  void onSearch() async {
    String searchText = _searchController.text.trim();

    if (searchText.isEmpty) {
      setState(() {
        hasSearched = false;
        userMap = null;
      });
      return;
    }

    setState(() {
      isLoading = true;
      hasSearched = true;
    });

    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    await _firestore
        .collection('users')
        .where('email', isEqualTo: searchText)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        setState(() {
          userMap = value.docs[0].data();
          isLoading = false;
        });
      } else {
        setState(() {
          userMap = null;
          isLoading = false;
        });
      }
    }).catchError((error) {
      setState(() {
        isLoading = false;
      });
    });
  }

  String getChatRoomId(String user1, String user2) {
    List<String> sortedEmails = [user1, user2]..sort();
    return "${sortedEmails[0]}_${sortedEmails[1]}";
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              ATextField(
                controller: _searchController,
                labelText: 'Search user by email',
                suffixIcon: Icon(Icons.search, size: 25),
                onTapSuffixIcon: onSearch,
              ),
              SizedBox(height: 20),
              isLoading
                  ? CircularProgressIndicator()
                  : hasSearched
                      ? userMap != null
                          ? ChatTile(
                              email: userMap!['email'],
                              role: userMap!['role'],
                              userId: userMap!['uid'],
                              onTap: () {
                                if (currentUserEmail != null) {
                                  String chatRoomId = getChatRoomId(
                                    currentUserEmail!,
                                    userMap!['email'],
                                  );
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChatRoom(
                                        userMap: userMap!,
                                        chatRoomId: chatRoomId,
                                      ),
                                    ),
                                  );
                                }
                              },
                            )
                          : Card(
                              child: ListTile(
                                title: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'No user found',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                      : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
