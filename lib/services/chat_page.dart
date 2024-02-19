import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'chatting_page.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Chats'),
      ),
      body: _buildUserGrid(),
    );
  }

  Widget _buildUserGrid() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Errors');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 5,
            crossAxisSpacing: 5,
          ),
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

    if (_auth.currentUser?.email != data['email']) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChattingPage(
                receiverUserEmail: data['email'],
                receiverUserID: data['uid'],
                receiverUsername: data['username'],
              ),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Material(
            elevation: 5,
            borderRadius: BorderRadius.circular(12),
            child: Column(

              children: [
                const SizedBox(height: 10),
                CircleAvatar(
                  backgroundImage: NetworkImage(data['profileImage'] ?? ''),
                  radius: 60,

                ),
                const SizedBox(height: 10),
                Text(data['username'] ?? data['email'],
                style:const TextStyle(
                  fontSize: 18,
                ) ,
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
}
