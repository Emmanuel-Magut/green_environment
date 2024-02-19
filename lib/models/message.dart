import 'package:cloud_firestore/cloud_firestore.dart';

class Message{
  final String senderId;
  final String senderEmail;
  final String receiverId;
  final String message;
  final String senderUserprofile;
  final String userName;
  final Timestamp timestamp;

  Message({
    required this.senderId,
    required this.senderEmail,
    required this.receiverId,
    required this.message,
    required this.timestamp,
    required this.senderUserprofile,
    required  this.userName,

});

  //convert to a map because that is how info is stored in firebase
  Map<String, dynamic> toMap(){
   return {
     'senderUserprofile': senderUserprofile,
     'userName':userName,
     'senderId': senderId,
     'senderEmail': senderEmail,
     'receiverId' : receiverId,
     'message' : message,
     'timestamp': timestamp,
   };
  }

}
