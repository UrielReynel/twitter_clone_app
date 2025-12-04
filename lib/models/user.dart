import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile{
  final String uid;
  final String email;
  final String name;
  final String username;
  final String bio;

  UserProfile({
    required this.uid,
    required this.email,
    required this.name,
    required this.username,
    required this.bio,
  });

  factory UserProfile.fromDocument(DocumentSnapshot doc){
    return UserProfile(
      uid: doc['uid'],
      email: doc['email'],
      name: doc['name'],
      username: doc['username'],
      bio: doc['bio'] ?? '',
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'username': username,
      'bio': bio,
    };
  }
}