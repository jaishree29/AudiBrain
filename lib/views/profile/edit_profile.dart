import 'dart:io';
import 'package:audibrain/utils/colors.dart';
import 'package:audibrain/views/profile/profile_info_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hive/hive.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final User? user = FirebaseAuth.instance.currentUser;
  final picker = ImagePicker();
  String? imagePath; // Store the image path

  @override
  void initState() {
    super.initState();
    loadImage();
  }

  // Load image from Hive
  void loadImage() async {
    final box = Hive.box('userBox');
    setState(() {
      imagePath = box.get('profileImagePath'); // Retrieve image path from Hive
    });
  }

  // Pick image and save to Hive
  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imagePath = pickedFile.path; // Update image path
      });
      final box = Hive.box('userBox');
      box.put('profileImagePath', imagePath); // Save image path to Hive
    }
  }

  Future<Map<String, dynamic>> getUserData(String userId) async {
    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return doc.data() as Map<String, dynamic>;
  }

  Future<void> updateUserData(
      String userId, Map<String, dynamic> updatedData) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .update(updatedData);
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('No user is logged in. Please log in.')),
      );
    }

    String userId = user!.uid;

    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>>(
          future: getUserData(userId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return const Center(child: Text('No user data found.'));
            }

            var userData = snapshot.data!;

            return Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: 240,
                      width: double.infinity,
                      color: AColors.primary,
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.arrow_back_ios_new_rounded,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                  SizedBox(width: 20,),
                                  Text(
                                    "Edit Profile",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white),
                                  ),
                                  Spacer(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 100,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: GestureDetector(
                          onTap: pickImage, // Call pickImage on tap
                          child: CircleAvatar(
                            radius: 55,
                            backgroundImage: imagePath != null
                                ? FileImage(File(imagePath!))
                                : const AssetImage('asset/images/ghost.png')
                                    as ImageProvider,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: ListView(
                      children: [
                        ProfileInfoPage(
                          label: 'Name',
                          initialValue: userData['Name'],
                          hintText: 'Enter your name here',
                          onChange: (newValue) async {
                            await updateUserData(userId, {'Name': newValue});
                          },
                        ),
                        ProfileInfoPage(
                          label: 'Email',
                          initialValue: userData['email'],
                          hintText: 'Enter your email here',
                          onChange: (newValue) async {
                            await updateUserData(userId, {'email': newValue});
                          },
                        ),
                        ProfileInfoPage(
                          label: 'Phone',
                          initialValue: userData['Phone Number'],
                          hintText: 'Enter your phone here',
                          onChange: (newValue) async {
                            await updateUserData(
                                userId, {'Phone Number': newValue});
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
