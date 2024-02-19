import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/profile_picture.dart';

class UserImage extends StatefulWidget {
  const UserImage({super.key});

  @override
  State<UserImage> createState() => _UserImageState();
}

class _UserImageState extends State<UserImage> {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data == null || !snapshot.data!.exists) {
          return const Text('No data for the user');
        } else {
          var userData = snapshot.data!.data() as Map<String, dynamic>;
          var profileImageUrl = userData['profileImage'] as String?;
          var username = userData['username'] as String?;

          return profileImageUrl != null
              ? GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfilePicturePage(),
                ),
              );
            },
            child: ClipOval(
              child: Image.network(
                profileImageUrl,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
          )
              : GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePicturePage(),
                ),
              );
            },
            child: const Icon(
              Icons.account_circle,
              size: 50,
              color: Colors.green,
            ),
          );
        }
      },
    );
  }
}
