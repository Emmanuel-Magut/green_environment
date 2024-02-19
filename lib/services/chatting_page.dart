import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:green_environment/models/chat_bubble.dart';
import 'package:green_environment/services/chat_service.dart';
import 'package:intl/intl.dart';

import '../pages/my_input_field.dart';
import '../pages/my_text_field.dart';

class ChattingPage extends StatefulWidget {

  final String receiverUserEmail;
  final String receiverUsername;
  final String receiverUserID;

   const ChattingPage({
    Key? key,
    required this.receiverUserEmail,
    required this.receiverUserID,
    required this.receiverUsername,

  }) : super(key: key);



  @override
  State<ChattingPage> createState() => _ChattingPageState();
}

class _ChattingPageState extends State<ChattingPage> {

  final user = FirebaseAuth.instance.currentUser!;

  DateTime? _previousDate; // Track the previous date
  String? selectedMessageId;
  String chatRoomId = '';

  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    chatRoomId = generateChatRoomId(_firebaseAuth.currentUser!.uid, widget.receiverUserID);

  //add  a listener to the focus node
    myFocusNode.addListener((){
      if(myFocusNode.hasFocus){
        //cause a delay so that the keyboard has time to show up
        //the amount of remainig space will be calculated
        //then scroll down            //500 is a duration that will wait for keyboard to show up
        Future.delayed(const Duration(milliseconds: 500),
                ()=>scrollDown());
      }
    });

    //wait a bit for listview to be built, then scroll to bottom
    Future.delayed(const Duration(milliseconds: 500),
        () => scrollDown(),
    );
  }

  @override
  void dispose(){
    myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

//for text field focus
  FocusNode myFocusNode = FocusNode();

//scroll controller
  final ScrollController _scrollController = ScrollController();
 void scrollDown(){
   _scrollController.animateTo(
       _scrollController.position.maxScrollExtent,
       duration: const Duration(seconds: 1),
       curve: Curves.fastOutSlowIn,
   );
 }

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
        widget.receiverUserID,
        _messageController.text,
      );
      _messageController.clear();
    }
    scrollDown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(
        widget.receiverUsername.isEmpty ? widget.receiverUserEmail : widget.receiverUsername,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontFamily: 'Literata',
        ),
      ),

        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          _buildMessageInput(),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatService.getMessages(
        widget.receiverUserID,
        _firebaseAuth.currentUser!.uid,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error' + snapshot.error.toString());
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading...');
        }

        return ListView.builder(
          controller: _scrollController,
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            return _buildMessageItem(snapshot.data!.docs[index]);
          },
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    DateTime messageDate =
    (data['timestamp'] as Timestamp).toDate(); // Convert Timestamp to DateTime
    DateTime currentDate =
    DateTime(messageDate.year, messageDate.month, messageDate.day);

    bool isNewDay = _previousDate == null || _previousDate!.isBefore(currentDate);
    _previousDate = currentDate;
bool isCurrentUser = data['senderId'] == user.uid;
    var alignment =
    isCurrentUser? Alignment.centerRight : Alignment.centerLeft;

    return Column(
      children: [
        if (isNewDay)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 20),
            child: Row(
              children: [
                const Expanded(child: Divider()),
                const SizedBox(width: 5),
                Text(
                  DateFormat('MMMM d, y').format(currentDate),
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 5),
                const Expanded(child: Divider()),
              ],
            ),
          ),
        Container(
          padding:const EdgeInsets.only(right: 10,left: 10, top:10),
          alignment: alignment,
          child: Column(
            crossAxisAlignment: 
            isCurrentUser ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
          ChatBubble(message: data['message'], isCurrentUser: isCurrentUser,

          ),

              Text(_formatTimestamp(data['timestamp']),
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
    
      ],
    )
    )
    ]
    );
  }

  void _deleteMessage(String messageId) async {
    try {
      print("Deleting message with ID: $messageId");
      await FirebaseFirestore.instance
          .collection('chat_rooms')
          .doc(chatRoomId)
          .collection('messages')
          .doc(messageId)
          .delete();
      if (kDebugMode) {
        print('Message deleted successfully.');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting message: $e');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to delete message. Please try again.'),
        ),
      );
    }
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Row(
        children: [
          Expanded(
            child: MyInputField(
              hintText: "Enter Message",
              controller: _messageController,
              obscureText: false,
              focusNode: myFocusNode,
            ),
          ),
          IconButton(
            onPressed: sendMessage,
            icon: const Icon(
              Icons.arrow_circle_right_sharp,
              size: 40,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('h:mm a').format(dateTime);
  }

  String generateChatRoomId(String currentUserId, String recipientUserId) {
    // Sort the user IDs alphabetically to ensure consistent ID generation
    List<String> userIds = [currentUserId, recipientUserId];
    userIds.sort();
    // Concatenate the sorted IDs with a hyphen to create a unique chat room ID
    return userIds.join('-');
  }

}
