import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/message.dart';

class ChatService extends ChangeNotifier{
  Future<String> getCurrentSender() async {
    final DocumentSnapshot snapshot = await _firestore.collection('users').doc(user.uid).get();
    if (snapshot.exists) {
      var userData = snapshot.data() as Map<String, dynamic>;
      var userProfile = userData['profileImage'] as String?;
      return userProfile ?? 'No profile';
    } else {
      return 'No profile found for the user';
    }
  }

  Future<String> getUsername() async {
    final DocumentSnapshot snapshot = await _firestore.collection('users').doc(user.uid).get();
    if (snapshot.exists) {
      var userData = snapshot.data() as Map<String, dynamic>;
      var userProfile = userData['username'] as String?;
      return userProfile ?? 'No Username';
    } else {
      return 'No Username';
    }
  }


  //get instance of auth and firestore
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser!;
  //SEND MESSAGE
Future<void> sendMessage(String receiverId, String message) async {
  //get current user info
   final String currentUserId = _firebaseAuth.currentUser!.uid;
   final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
   String currentSender = await getCurrentSender();
   String userName = await getUsername();


   final Timestamp timestamp = Timestamp.now();
  //create a new message
   Message newMessage = Message(
       senderId: currentUserId,
       senderEmail: currentUserEmail,
     senderUserprofile : currentSender,
     userName : userName,
     receiverId: receiverId,
     timestamp: timestamp,
     message: message,
   );
  //construct a chat room id from current user id and receiver
   List<String> ids = [currentUserId, receiverId];
   ids.sort(); //sort the ids(this ensures the chat room id is always the same for any pair of people)
  String chatRoomId = ids.join("_");//combine the ids into a single string to use as a chatroomID


  //add new message to database
  await _firestore
      .collection('chat_rooms')
      .doc(chatRoomId)
      .collection('messages')
      .add(newMessage.toMap());

}

  //GET MESSAGES
  Stream<QuerySnapshot> getMessages(String userId, String otherUserId){
  //construct chat room id from user ids(sorted to ensure it matches the id used when sending)
  List<String> ids = [userId, otherUserId];
  ids.sort();
  String chatRoomId = ids.join("_");

  return _firestore
      .collection('chat_rooms')
      .doc(chatRoomId)
      .collection('messages')
      .orderBy('timestamp', descending: false)
  .snapshots();
  }


  // Inside ChatService class
  Future<List<DocumentSnapshot>> getChattedUsers() async {
    final currentUserId = _firebaseAuth.currentUser!.uid;

    final querySnapshot = await _firestore
        .collection('chat_rooms')
        .where('users', arrayContains: currentUserId)
        .get();

    return querySnapshot.docs;
  }


}