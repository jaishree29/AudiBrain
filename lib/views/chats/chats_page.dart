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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  // Fetch all chat rooms where the current user is involved
  Stream<List<QueryDocumentSnapshot>> getRecentChats() {
    return _firestore.collection('chatrooms').snapshots().map((snapshot) {
      return snapshot.docs.where((doc) {
        String chatRoomId = doc.id;
        List<String> participants = chatRoomId.split('_');
        return participants.contains(currentUserEmail);
      }).toList();
    });
  }

  // Fetch the latest message from a chat room
  Future<Map<String, dynamic>?> getLatestMessage(String chatRoomId) async {
    var messagesSnapshot = await _firestore
        .collection('chatrooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('time', descending: true)
        .limit(1)
        .get();

    if (messagesSnapshot.docs.isNotEmpty) {
      return messagesSnapshot.docs[0].data();
    }
    return null;
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
              SizedBox(height: 20),
              StreamBuilder<List<QueryDocumentSnapshot>>(
                stream: getRecentChats(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    print("No recent chats found");
                    return Center(child: Text("No recent chats"));
                  }

                  var chatRooms = snapshot.data!;
                  print("Chat Rooms: ${chatRooms.length}");

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: chatRooms.length,
                    itemBuilder: (context, index) {
                      String chatRoomId = chatRooms[index].id;
                      List<String> participants = chatRoomId.split('_');
                      print("Chat Room ID: $chatRoomId");
                      print("Participants: $participants");

                      String otherUserEmail = participants
                          .firstWhere((email) => email != currentUserEmail);
                      print("Other User Email: $otherUserEmail");

                      return FutureBuilder<DocumentSnapshot>(
                        future: _firestore
                            .collection('users')
                            .doc(otherUserEmail)
                            .get(),
                        builder: (context, userSnapshot) {
                          if (userSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return SizedBox();
                          }

                          if (!userSnapshot.hasData ||
                              !userSnapshot.data!.exists) {
                            print("User not found: $otherUserEmail");
                            return SizedBox();
                          }

                          var userData =
                              userSnapshot.data!.data() as Map<String, dynamic>;
                          print("User Data: $userData");

                          return FutureBuilder<Map<String, dynamic>?>(
                            future: getLatestMessage(chatRoomId),
                            builder: (context, messageSnapshot) {
                              if (messageSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return SizedBox();
                              }

                              var latestMessage = messageSnapshot.data;
                              print("Latest Message: $latestMessage");

                              return ChatTile(
                                email: userData['email'],
                                role: userData['role'],
                                userId: userData['uid'],
                                latestMessage: latestMessage?['message'],
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChatRoom(
                                        userMap: userData,
                                        chatRoomId: chatRoomId,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
