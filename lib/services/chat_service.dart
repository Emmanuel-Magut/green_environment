import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../models/message.dart';

class ChatService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final User user = FirebaseAuth.instance.currentUser!;

  User get currentUser => _firebaseAuth.currentUser!;

  Future<User?> getCurrentUser() async {
    return _firebaseAuth.currentUser;
  }

  Future<String> getOtherUserId(String chatRoomId) async {
    try {
      final chatRoomDoc = await _firestore.collection('chat_rooms').doc(chatRoomId).get();
      final List<String> users = List<String>.from(chatRoomDoc['users']);

      return users.firstWhere((id) => id != currentUser.uid, orElse: () => '');
    } catch (error) {
      print('Error fetching otherUserId: $error');
      return '';
    }
  }

  Future<String> getCurrentSender() async {
    final DocumentSnapshot snapshot =
    await _firestore.collection('users').doc(user.uid).get();
    if (snapshot.exists) {
      var userData = snapshot.data() as Map<String, dynamic>;
      var userProfile = userData['profileImage'] as String?;
      return userProfile ?? 'No profile';
    } else {
      return 'No profile found for the user';
    }
  }

  Future<String> getUsername() async {
    final DocumentSnapshot snapshot =
    await _firestore.collection('users').doc(user.uid).get();
    if (snapshot.exists) {
      var userData = snapshot.data() as Map<String, dynamic>;
      var userProfile = userData['username'] as String?;
      return userProfile ?? 'No Username';
    } else {
      return 'No Username';
    }
  }

  Future<void> sendMessage(String receiverId, String message, {bool isRead = false}) async {
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    String currentSender = await getCurrentSender();
    String userName = await getUsername();

    final Timestamp timestamp = Timestamp.now();
    Message newMessage = Message(
      senderId: currentUserId,
      senderEmail: currentUserEmail,
      senderUserprofile: currentSender,
      userName: userName,
      receiverId: receiverId,
      timestamp: timestamp,
      message: message,
      isRead: false,
    );

    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    String chatRoomId = ids.join("_");

    // Get the current chat room document
    DocumentSnapshot chatRoomDoc = await _firestore.collection('chat_rooms').doc(chatRoomId).get();



    // Create or update the chat room document
    await _firestore.collection('chat_rooms').doc(chatRoomId).set({
      'hiddenBy': FieldValue.arrayUnion([]),
      'users': FieldValue.arrayUnion([currentUserId, receiverId]),
     // 'hiddenMessages_$currentUserId': FieldValue.arrayUnion([]), // Initialize the field if it doesn't exist
      'hiddenMessages': {
        '$currentUserId': {
          'messageIds': [], // Initialize the array
        },
      }, // Initialize the field if it doesn't exist
      'timestamp': FieldValue.serverTimestamp(), // Update timestamp with server timestamp
    }, SetOptions(merge: true));

    // Add the message to the messages subcollection
    await _firestore.collection('chat_rooms').doc(chatRoomId).collection('messages').add(
      newMessage.toMap(),
    );
    // Remove the current user's ID from hiddenBy list if it exists
    if (chatRoomDoc['hiddenBy'] != null) {
      List<Map<String, dynamic>> hiddenByList =
      List<Map<String, dynamic>>.from(chatRoomDoc['hiddenBy']);
      hiddenByList.removeWhere((entry) => entry['userId'] == currentUserId);

      await _firestore.collection('chat_rooms').doc(chatRoomId).update({
        'hiddenBy': hiddenByList,

      });
    }



  }



/*
  //simple get messages
  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");

    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .snapshots()
        .asyncMap((chatRoomDoc) async {
      if (chatRoomDoc.exists) {
        final hiddenMessages =
        Map<String, dynamic>.from(chatRoomDoc['hiddenMessages'] ?? {});

        final querySnapshot = await _firestore
            .collection('chat_rooms')
            .doc(chatRoomId)
            .collection('messages')
            .orderBy('timestamp', descending: false)
            .get();

        final filteredMessages = querySnapshot.docs.where((doc) =>
        !hiddenMessages.containsKey('$userId.uid') ||
            !hiddenMessages['$userId.uid']['messageIds'].contains(doc.id));

        // Return the original snapshot with filtered messages
        return QuerySnapshot(
          querySnapshot.docs,  // Pass the list of filtered documents
          docChanges: querySnapshot.docChanges,
          metadata: querySnapshot.metadata,
        );
      } else {
        // Return an empty snapshot if the chat room document doesn't exist
        return QuerySnapshot(
          [],  // Pass an empty list for docs
          docChanges: [],
          metadata: SnapshotMetadata(
            hasPendingWrites: false,
            isFromCache: false,
            source: MetadataSource.server,
          ),
        );
      }
    });
  }
*/

  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
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




  Future<List<QuerySnapshot>> getMessagesForChatRoom(String chatRoomId) async {
    try {
      // Retrieve messages where the current user is either the sender or receiver
      final messageSnapshot = await _firestore
          .collection('chat_rooms')
          .doc(chatRoomId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .get();

      return [messageSnapshot];
    } catch (error) {
      print(error);
      return [];
    }
  }


  Future<List<Map<String, dynamic>>> getInboxMessages() async {
    final currentUserId = _firebaseAuth.currentUser!.uid;

    try {
      // Fetch chat rooms involving the current user
      final querySnapshot = await _firestore
          .collection('chat_rooms')
          .where('users', arrayContains: currentUserId)
          .get();

      final List<Map<String, dynamic>> chatRoomsData = [];

      for (final chatRoomDoc in querySnapshot.docs) {
        final chatRoomId = chatRoomDoc.id;
        final List<dynamic>? hiddenBy = chatRoomDoc['hiddenBy'];

        if (hiddenBy == null ||
            !hiddenBy
                .cast<Map<String, dynamic>>()
                .any((item) => item['userId'] == currentUserId)) {
          final otherUserId = (chatRoomDoc['users'] as List)
              .cast<String>()
              .firstWhere((id) => id != currentUserId, orElse: () => '');

          if (otherUserId.isNotEmpty) {
            chatRoomsData.add({
              'chatRoomId': chatRoomId,
              'otherUserId': otherUserId,
            });
          }
        }
      }

      return chatRoomsData;
    } catch (error) {
      print('Error fetching inbox messages: $error');
      return [];
    }
  }


  Future<List<String>> getChatRoomIdsForUser() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    final QuerySnapshot querySnapshot = await _firestore
        .collection('chat_rooms')
        .where('users', arrayContains: userId)
        .get();

    final List<String> chatRoomIds = querySnapshot.docs
        .map((doc) => doc.id)
        .toList();

    return chatRoomIds;
  }

  Future<List<QuerySnapshot>> getMessagesForCurrentUser() async {
    final userId = _firebaseAuth.currentUser!.uid;

    // Construct chat room ID based on the current user
    final chatRoomId = "chat_$userId";

    try {
      final messageSnapshot = await _firestore
          .collection('chat_rooms')
          .doc(chatRoomId)
          .collection('messages')
         .where('senderId', isEqualTo: userId)
          .where('receiverId', isEqualTo: userId)
          .orderBy('timestamp', descending: false)
          .get();

      return [messageSnapshot];
    } catch (error) {
      print(error);
      return [];
    }
  }

  Future<String> getUsernameByOtherUserId( String otherUserId) async {
    try {
      print('Fetching username for otherUserId: $otherUserId');

      final querySnapshot = await _firestore
          .collection('users')
          .where('uid', isEqualTo: otherUserId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final userData = querySnapshot.docs.first.data();
        final username = userData['username'] as String?;

        print('Username for otherUserId $otherUserId: $username');

        return username ?? 'No Username';
      } else {
        print('No user found for otherUserId: $otherUserId');
        return 'No User Found';
      }
    } catch (error) {
      print('Error fetching username: $error');
      return 'Error Fetching Username';
    }
  }



  Future<String> getLastMessage(String chatRoomId) async {
    try {
      final querySnapshot = await _firestore
          .collection('chat_rooms')
          .doc(chatRoomId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final lastMessageData = querySnapshot.docs.first.data();
        final lastMessage = lastMessageData['message'] ;
        return lastMessage ?? 'No Message';
      } else {
        return 'No Messages in Chat Room';
      }
    } catch (error) {
      print(error);
      return 'Error Fetching Last Message';
    }
  }
  Future<Map<String, dynamic>> getLastMessageDetails(String chatRoomId) async {
    // Adjust this query to match your database structure
    final querySnapshot = await _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final Map<String, dynamic> lastMessage = querySnapshot.docs.first.data();
      return lastMessage;
    } else {
      return {}; // Return an empty map if no messages are found
    }
  }

//sets new isRead to true when a user opens messages
  Future<void> setIsRead(String messageId, String chatRoomId) async {
    await FirebaseFirestore.instance
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .doc(messageId)
        .update({'isRead': true});
  }
//delete inbox
  Future<void> deleteChatRoom(String chatRoomId) async {
    try {
      // Delete messages in the chat room
      await FirebaseFirestore.instance
          .collection('chat_rooms')
          .doc(chatRoomId)
          .collection('messages')
          .get()
          .then((querySnapshot) {
        for (QueryDocumentSnapshot doc in querySnapshot.docs) {
          doc.reference.delete();
        }
      });

      // Delete the chat room itself
      await FirebaseFirestore.instance
          .collection('chat_rooms')
          .doc(chatRoomId)
          .delete();

      print('Chat Room Deleted');
    } catch (error) {
      print('Failed to delete chat room: $error');
    }
  }

  //hides chatroom
  Future<void> hideChatRoom(String chatRoomId) async {
    try {
      final currentUserId = _firebaseAuth.currentUser!.uid;

      // Get the current timestamp
      final Timestamp currentTimestamp = Timestamp.now();

      // Get the message IDs in the chat room
      final QuerySnapshot messageSnapshot = await _firestore
          .collection('chat_rooms')
          .doc(chatRoomId)
          .collection('messages')
          .get();

      final List<String> messageIds = messageSnapshot.docs
          .map((doc) => doc.id)
          .toList();

      // Update the chat room's hiddenMessages array with the message IDs
      await _firestore.collection('chat_rooms').doc(chatRoomId).update({
        'hiddenBy': FieldValue.arrayUnion([
          {
            'userId': currentUserId,
            'timestamp': currentTimestamp,
          }
        ]),
      });

      // Iterate through messageIds and update hiddenMessages accordingly
      for (String messageId in messageIds) {
        await _firestore.collection('chat_rooms').doc(chatRoomId).update({
          'hiddenMessages.$currentUserId.uid.messageIds': FieldValue.arrayUnion([messageId]),
        });
      }

      print('Chat Room $chatRoomId marked as hidden.');
    } catch (error) {
      print('Failed to hide chat room: $error');
      // Handle the error as needed
    }
  }



}
