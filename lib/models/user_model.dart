import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String? uid;
  final String? email;
  final String? role; // 'user' or 'pwd'
  final String? language; // Default language

  UserModel({this.uid, this.email, this.role, this.language});

  factory UserModel.fromFirebase(User? user) {
    return UserModel(
      uid: user?.uid,
      email: user?.email,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'role': role,
      'language': language,
    };
  }
}
