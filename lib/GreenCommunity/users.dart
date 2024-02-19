import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/chatting_page.dart';

class Users extends StatefulWidget {
  const Users({Key? key}) : super(key: key);

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildUserGrid(),
    );
  }

  Widget _buildUserGrid() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            return _buildUserGridItem(snapshot.data!.docs[index]);
          },
        );
      },
    );
  }

  Widget _buildUserGridItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    if (FirebaseAuth.instance.currentUser?.email != data['email']) {
      return GestureDetector(
        onTap: () => _showUserDetailsDialog(context, data), // Open dialog on tap
        child: Padding(
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: Material(
            elevation: 2,
            borderRadius: BorderRadius.circular(12),
            child: Column(
              children: [
                Container(
                  height: 100, // Adjust the height of the circular image
                  width: 100, // Adjust the width of the circular image
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40), // Half of the width/height for a circle
                    child: data['profileImage'] != null && data['profileImage'] != ''
                        ? Image.network(
                      data['profileImage'],
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    )
                        : Container(
                      padding: const EdgeInsets.all(5),
                      color: Colors.grey, // Background color if no image
                      child: const Icon(Icons.person, size: 100, color: Colors.white), // Fallback Icon
                    ),
                  ),
                ),
                const SizedBox(height: 5), // Add spacing between image and username
                Text(data['username'] ?? '',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                ),
              ],
            ),
          ),
        ),

      );
    } else {
      return Container();
    }
  }

  void _showUserDetailsDialog(BuildContext context, Map<String, dynamic> userData) {
    TextEditingController messageController = TextEditingController(); // For message

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(userData['username']),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(
                userData['profileImage'] ?? '',
                width: 80,
                height: 80,
              ),
              Text(userData['email']),
              // ... Add other detailss as needed


            ],
          ),
          actions: [
            // Send message button
            ElevatedButton(
              onPressed: () {
                // Navigate to ChattingPage and send message (implementation needed)
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChattingPage(
                      // Pass user data and message
                      receiverUserEmail: userData['email'],
                      receiverUserID: userData['uid'],
                      receiverUsername: userData['username'],

                    ),
                  ),
                );
              },
              child: const Text('Send message'),
            ),
          ],
        );
      },
    );
  }
}
