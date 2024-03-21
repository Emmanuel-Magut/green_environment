import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:green_environment/models/chat_bubble.dart';
import 'package:green_environment/services/chat_service.dart';
import 'package:intl/intl.dart';
import '../DateTimeFormat/date_time.dart';
import '../pages/my_input_field.dart';

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
    chatRoomId =
        generateChatRoomId(_firebaseAuth.currentUser!.uid, widget.receiverUserID);

    // add a listener to the focus node
    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        // cause a delay so that the keyboard has time to show up
        // the amount of remaining space will be calculated
        // then scroll down
        // 500 is a duration that will wait for the keyboard to show up
        Future.delayed(
          const Duration(milliseconds: 200),
              () => scrollDown(),
        );
      }
    });

    // wait a bit for the listview to be built, then scroll to the bottom
    Future.delayed(
      const Duration(milliseconds: 200),
          () => scrollDown(),
    );
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  // for text field focus
  FocusNode myFocusNode = FocusNode();

  // scroll controller
  final ScrollController _scrollController = ScrollController();

  void scrollDown() {
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
        isRead: false, // Set isRead to false for sent messages
      );
      _messageController.clear();
      scrollDown(); // Scroll down after sending the message
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _buildAppBarTitle(),
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

        // Get the messages
        var messages = snapshot.data!.docs;

        // Set isRead to true for unread messages and update in Firestore
        for (var message in messages) {
          if (message['senderId'] == widget.receiverUserID && !message['isRead']) {
            String messageId = message.id;
            _chatService.setIsRead(messageId, chatRoomId);
          }
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

    DateTime messageDate = (data['timestamp'] as Timestamp).toDate();
    DateTime currentDate = DateTime(messageDate.year, messageDate.month, messageDate.day);

    bool isNewDay = _previousDate == null || _previousDate!.isBefore(currentDate);
    _previousDate = currentDate;
    bool isCurrentUser = data['senderId'] == user.uid;
    bool isRead = data['isRead'] ?? false;

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
                  style: const TextStyle(
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
          padding: const EdgeInsets.only(right: 10, left: 10, top: 10),
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: isCurrentUser
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              // Wrap ChatBubble with GestureDetector for long press
              GestureDetector(
                onLongPress: () {
                  // Handle long press here
                  setState(() {
                    selectedMessageId = document.id;
                  });
                },
                child: ChatBubble(
                  message: data['message'],
                  isCurrentUser: isCurrentUser,
                ),
              ),
              if (selectedMessageId == document.id && isCurrentUser)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        // Call the delete function when the delete icon is pressed
                        _deleteMessage(selectedMessageId!);
                        setState(() {
                          selectedMessageId = null;
                        });
                      },
                    ),
                  ],
                ),
              Row(
                mainAxisAlignment: isCurrentUser
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
                children: [
                  Text(
                    _formatTimestamp(data['timestamp']),
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  if (isCurrentUser)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.done_all,
                          color: isRead ? Colors.blue : Colors.grey,
                          size: 18,
                        ),
                      ],
                    ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }


  void _deleteMessage(String messageId) async {
    // Show a confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Center(
            child: Text("Delete Message")
        ),
        content: const Text("Are you sure you want to delete this message?",
        style:TextStyle(
          fontSize: 16,
        )
        ),
        actions: [
          // CANCEL BUTTON
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.only(left:15, right:15, top:10, bottom: 10),
              decoration:  BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(12),
              ),
                child: const Text("Cancel",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                ),
            ),
          ),
          // DELETE BUTTON
          TextButton(
            onPressed: () async {
              // Delete the message
              await FirebaseFirestore.instance
                  .collection('chat_rooms')
                  .doc(chatRoomId)
                  .collection('messages')
                  .doc(messageId)
                  .delete()
                  .then((value) => {
                    Fluttertoast.showToast(
                        msg: "Deleted Successfully",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 6,
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                        fontSize: 18.0
                    )
                  });
              // Close the dialog box
              Navigator.pop(context);
            },
            child: Container(
                padding: const EdgeInsets.only(left:15, right:15, top:10, bottom: 10),
                decoration:  BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text("Delete",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                )
            ),
          ),
        ],
      ),
    );
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

  Widget _buildAppBarTitle() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .where('uid', isEqualTo: widget.receiverUserID)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text(
            widget.receiverUsername.isEmpty
                ? widget.receiverUserEmail
                : widget.receiverUsername,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontFamily: 'Literata',
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(
            color: Colors.white,
          );
        }

        if (snapshot.data!.docs.isEmpty) {
          // Handle the case where no matching user is found
          return const Text('User not found',
          style:TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          )
          );
        }

        final userData = snapshot.data!.docs[0].data() as Map<String, dynamic>;
        final isOnline = userData['isOnline'] ?? false;
        final lastSeenTimestamp = userData['lastSeen'] as Timestamp?;
        final LastSeen = lastSeenTimestamp != null
            ? formatDate(lastSeenTimestamp)
            : 'Last seen recently';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: userData['profileImage'] != null && userData['profileImage'] != ''
                      ? Image.network(
                    userData['profileImage'],
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  )
                      : Container(
                    padding: const EdgeInsets.all(5),
                    color: Colors.grey,
                    child: const Icon(Icons.person, size: 100, color: Colors.white),
                  ),
                ),
                SizedBox(width:4),
                Column(
                  children: [
                    Text(
                      widget.receiverUsername.isEmpty
                          ? widget.receiverUserEmail
                          : widget.receiverUsername,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontFamily: 'Literata',
                      ),
                    ),
                    Text(
                      isOnline ? 'Online' : LastSeen,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),

          ],
        );
      },
    );
  }
}

