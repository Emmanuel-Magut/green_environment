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
  @override
  void initState() {
    super.initState();
    // Call setUserOnlineStatus(true) when the user logs in
    setUserOnlineStatus(true);
  }
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
          return const Text('No data for the users');
        } else {
          var userData = snapshot.data!.data() as Map<String, dynamic>;
          var profileImageUrl = userData['profileImage'] as String?;

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
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: userData['profileImage'] != null && userData['profileImage'] != ''
                      ? Image.network(
                    profileImageUrl,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  )
                      : Container(
                    padding: const EdgeInsets.all(5),
                    color: Colors.grey,
                    child: const Icon(Icons.person, size: 100, color: Colors.white),
                  ),
                ),
                if (userData['isOnline'] ?? false)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.shade400,

                        ),
                        color: Colors.lightGreen,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
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

  void setUserOnlineStatus(bool isOnline) async {
    // Get the current user's UID
    String? uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid != null) {
      // Update the isOnline field in Firestore
      await FirebaseFirestore.instance.collection('users').doc(uid).update({'isOnline': isOnline});
    }
  }
}
