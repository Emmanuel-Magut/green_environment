import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../DateTimeFormat/date_time.dart';
import '../services/chat_service.dart';
import '../services/chatting_page.dart';

class InboxScreen extends StatefulWidget {
  @override
  _InboxScreenState createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  bool showDeleteIcon = false;
  bool isMounted = false;
  void toggleDeleteIcon() {
    if (isMounted) {
      setState(() {
        showDeleteIcon = !showDeleteIcon;
      });
    }
  }
  @override
  void initState() {
    super.initState();
    isMounted = true;
  }

  @override
  void dispose() {
    isMounted = false;
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final chatService = Provider.of<ChatService>(context);

    return Scaffold(
      appBar: AppBar(
      backgroundColor: Colors.green,
      title: const Text(
        'Chats',
        style: TextStyle(
          letterSpacing: 4,
          fontSize: 30,
          fontWeight: FontWeight.bold,
          fontFamily: "Lobster",
          color: Colors.white,
        ),
      ),
        actions: const [
          //
        ],
    ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: chatService.getInboxMessages(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(
              color: Colors.green,
            ));
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error fetching messages'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text('No messages to display')
            );
          }

          final messageSnapshots = snapshot.data!;

          return ListView.builder(
            itemCount: messageSnapshots.length,
            itemBuilder: (context, index) {
              final chatRoomData = messageSnapshots[index];

              // Accessing chat room data directly from the list
              final chatRoomId = chatRoomData['chatRoomId'];
              final otherUserIdFuture = chatService.getOtherUserId(chatRoomId);

              return FutureBuilder<String>(
                future: otherUserIdFuture,
                builder: (context, otherUserIdSnapshot) {
                  if (otherUserIdSnapshot.connectionState == ConnectionState.waiting) {
                    return  Container();
                  } else if (otherUserIdSnapshot.hasError) {
                    return Container();//Center(child: Text('Error fetching otherUserIds'));
                  }
                  final String otherUserId = otherUserIdSnapshot.data ?? 'Unknown User';
                  //  print('Other User ID for Chat Room $chatRoomId: $otherUserId');
                  final usernameFuture = chatService.getUsernameByOtherUserId(otherUserId);

                  return FutureBuilder<String>(
                    future: usernameFuture,
                    builder: (context, usernameSnapshot) {
                      if (usernameSnapshot.connectionState == ConnectionState.waiting) {
                        return  Container(); // Show a loading indicator
                      } else if (usernameSnapshot.hasError) {
                        print('Username Future: Error fetching username: ${usernameSnapshot.error}');
                        return Text('Error fetching username: ${usernameSnapshot.error}'); // Detailed error message
                      }

                      final String username = usernameSnapshot.data ?? 'Unknown User';


                      if (username.isNotEmpty) {
                        final List<String> usernamesList = username.split(',');

                        for (String user in usernamesList) {
                          print('Username: $user');
                        }
                      }

                      if (username.isEmpty) {
                        print('Username: No User Found');
                        return const Text('No User Found');
                      }

                      return _buildListTileContent(context, chatService, chatRoomId, otherUserId, username);
                    },
                  );
                },
              );
            },
          );

        },
      ),
    );
  }

  Widget _buildListTileContent(
      BuildContext context,
      ChatService chatService,
      String chatRoomId,
      String otherUserId,
      String username,
      ) {
    //print('Other User ID for Chat Room $chatRoomId: $otherUserId');

     return GestureDetector(
       onTap: () {
         _handleTileTap(context, otherUserId, chatService);
       },
       onLongPress: () {
         _deleteChatRoom(context, chatService, chatRoomId);
       },
       child: Container(
         decoration:  BoxDecoration(
           border: Border.all(
             color: Colors.grey,
           )
         ),
        padding: const EdgeInsets.all(8.0),
        child: Row(

          children: [
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .where("uid", isEqualTo: otherUserId)
                  .snapshots(),
              builder: (context, userSnapshot) {
                if (userSnapshot.hasData) {
                  String image = "";

                  if (userSnapshot.data!.docs.isNotEmpty) {
                    image = userSnapshot.data!.docs[0].get("profileImage");
                    username = userSnapshot.data!.docs[0].get("username");
                  }

                  return Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(image),
                        radius: 30,
                      ),
                    ],
                  );
                } else if (userSnapshot.hasError) {
                  return Container();
                } else {
                  return Container();
                }
              },
            ),
            FutureBuilder<String>(
              future: chatService.getLastMessage(chatRoomId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(); // You can show loading indicators
                } else if (snapshot.hasError) {
                  return Container();
                }

                final String lastMessage = snapshot.data ?? 'No Messages';

                final Future<Map<String, dynamic>> messageDetailsFuture =
                chatService.getLastMessageDetails(chatRoomId);

                return FutureBuilder<Map<String, dynamic>>(
                  future: messageDetailsFuture,
                  builder: (context, messageDetailsSnapshot) {
                    if (messageDetailsSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Container(); // Show a loading indicator
                    } else if (messageDetailsSnapshot.hasError) {
                      return Container();
                    }

                    final Map<String, dynamic> messageDetails =
                        messageDetailsSnapshot.data ?? {};

                    final timesent = formatDate(messageDetails['timestamp']);

                    final truncatedMessage = lastMessage.length > 30
                        ? '${lastMessage.substring(0, 30)}...'
                        : lastMessage;

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                username,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  Text(truncatedMessage,
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                  ),
                                  const SizedBox(width: 20),
                                  Text(
                                    timesent,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
           ),
     );
  }
  Future<void> _deleteChatRoom(
      BuildContext context,
      ChatService chatService,
      String chatRoomId,
      ) async {
    if (!isMounted) {
      return; // Widget is not mounted, avoid performing operations
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Center(
          child: Text("Delete Chat",
          style: TextStyle(
            fontFamily: "Georgia",

          ),
          ),
        ),
        content: const Text("Are you sure you want to delete this chat?",
          style: TextStyle(
            fontSize: 16,
          ),

        ),
        actions: [
          // CANCEL BUTTON
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.only(left:15, right:15, top:10, bottom: 10),
              decoration:  BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.green,
              ),
                child: const Text("Cancel",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                )
            ),
          ),
          // DELETE BUTTON
          TextButton(
            onPressed: () async {
              // Hide the chat room
              await chatService.hideChatRoom(chatRoomId);

              // Close the dialog box
              Navigator.pop(context);
            },
            child: Container(
                padding: const EdgeInsets.only(left:15, right:15, top:10, bottom: 10),
                decoration:  BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.green,
                ),
                child: const Text("Delete",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ),
          ),
        ],
      ),
    );
  }


  Future<void> _handleTileTap(BuildContext context, String otherUserId, ChatService chatService) async {
    final receiverUsername = await chatService.getUsernameByOtherUserId(otherUserId);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChattingPage(
          receiverUserEmail: otherUserId,
          receiverUserID: otherUserId,
          receiverUsername: receiverUsername,
        ),
      ),
    );
  }
}
