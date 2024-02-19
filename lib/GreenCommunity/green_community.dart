import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:green_environment/GreenCommunity/post_image.dart';
import 'package:green_environment/GreenCommunity/posts.dart';
import 'package:green_environment/GreenCommunity/posts_input_field.dart';
import 'package:green_environment/GreenCommunity/user_image.dart';
import 'package:green_environment/GreenCommunity/users.dart';
import 'package:green_environment/pages/home_page.dart';
import '../DateTimeFormat/date_time.dart';
import '../services/chatting_page.dart';

class GreenCommunity extends StatefulWidget {
  const GreenCommunity({Key? key});

  @override
  State<GreenCommunity> createState() => _GreenCommunityState();
}

class _GreenCommunityState extends State<GreenCommunity> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final textController = TextEditingController();
  //pop up for user to post something

  void saySomething() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Center(
          child: Column(
            children: [
              Text('Add Post',
              style: TextStyle(
                fontFamily: 'Georgia',
              ),
              ),
              Row(
                children: [
                  Icon(Icons.warning,
                    color: Colors.red,
                    size: 18,
                  ),
                  Text('Post only content related to climate change and environment.',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.warning,
                    color: Colors.red,
                    size: 18,
                  ),
                  Text('No advertisements/politics. No abusive language.',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.done,
                    color: Colors.green,
                    size: 18,
                  ),
                  Text('Share your recent environmental actions.',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.done,
                    color: Colors.green,
                    size: 18,
                  ),
                  Text('Invite others to env activities near you e.g tree planting.',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        contentPadding: const EdgeInsets.all(20.0), // Adjust the padding as needed
        content: Container(
          width: double.maxFinite, // Adjust the width as needed
          child: MyPostsInputField(
            hintText: 'Say something...',
            controller: textController,
            obscureText: false,
            focusNode: null,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                textController.clear();
              });
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text('Cancel',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,

              ),
              ),
            ),
          ),
          TextButton(
            onPressed: postMessage,
            child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text('Post',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,

                  ),
                )
            ),
          ),
        ],
      ),
    );
  }



  void postMessage() {
    if (textController.text.isNotEmpty) {
      FirebaseFirestore.instance.collection('Posts').add({
        "UserEmail": currentUser.email,
        "imagePost": "",
        "message": textController.text,
        "TimeStamp": Timestamp.now(),
        "Likes": [],
      });
    }

    setState(() {
      textController.clear();
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const UserImage(),
                            GestureDetector(
                              onTap: saySomething,
                              child: Container(
                                padding: const EdgeInsets.only(left: 40, right: 40, top: 10, bottom: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.green,
                                  ),
                                ),
                                child: const Text("Say Something..."),
                              ),
                            ),


                             Column(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => PostImage())
                                    );
                                  },
                                  icon: const Icon(Icons.photo,
                                  size: 30,
                                  color: Colors.green),
                                ),
                                const Text("Image",
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const Icon(Icons.message_rounded,
                              size: 30,
                              color: Colors.green,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height:10),
                      Divider(color: Colors.green.shade200),
                      const SizedBox(height: 1),

                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 140,
                        child: const Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Users(),
                        ),
                      ),
                      StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("Posts")
                            .orderBy("TimeStamp", descending: true)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                final post = snapshot.data!.docs[index];
                                String email = post['UserEmail'];

                                Stream<QuerySnapshot> userStream = FirebaseFirestore.instance
                                    .collection("users")
                                    .where("email", isEqualTo: email)
                                    .snapshots();

                                return StreamBuilder<QuerySnapshot>(
                                  stream: userStream,
                                  builder: (context, userSnapshot) {
                                    if (userSnapshot.hasData) {
                                      String username = "";
                                      String image = "";
                                      String profession = "";
                                      String uid = "";
                                      if (userSnapshot.data!.docs.isNotEmpty) {
                                        username = userSnapshot.data!.docs[0].get("username");
                                        image = userSnapshot.data!.docs[0].get("profileImage");
                                        profession = userSnapshot.data!.docs[0].get("profession");
                                        uid   = userSnapshot.data!.docs[0].get("uid");
                                        email = userSnapshot.data!.docs[0].get("email");
                                      }
                                      return WallPosts(
                                        commentId: post.id,
                                          image: image,
                                          message: post['message'],
                                          userEmail: post['UserEmail'],
                                          postImage: post['imagePost'] != null ? post['imagePost'] : null,
                                          user: username,
                                        profession: profession,
                                        time: formatDate(post['TimeStamp']),
                                        id: post.id,
                                        likes: List<String>.from(post['Likes'] ?? []),
                                          onTap:
                                              ()async {
                                          // Option 1: Show Dialog
                                       showDialog(
                                           context: context,
                                           builder: (context) => AlertDialog(
                                             title: Text(username),
                                             content: Column(
                                               mainAxisSize: MainAxisSize.min, // Prevent content scrolling
                                               children: [
                                                 CircleAvatar(
                                                   radius: 30,
                                                   backgroundImage: NetworkImage(image),
                                                 ),
                                                 SizedBox(height: 10),
                                                 Text(username), // Show both username and email
                                               ],
                                             ),
                                             actions: [
                                               TextButton(
                                                 onPressed: () => Navigator.pop(context),
                                                 child: const Text("Close"),
                                               ),
                                             //  if (widget. == currentUser.uid)
                                                 TextButton(
                                                   onPressed: () {
                                                     // Handle the action when the button is pressed
                                                     // Navigate to ChattingPage and send message (implementation needed)
                                                     Navigator.push(
                                                       context,
                                                       MaterialPageRoute(
                                                         builder: (context) => ChattingPage(
                                                           // Pass user data and message
                                                           receiverUserEmail: post['UserEmail'],
                                                           receiverUserID: uid,
                                                           receiverUsername: username,
                                                         ),
                                                       ),
                                                     );
                                                   },
                                                   child: const Text('Send message'),
                                                 ),
                                             ],

                                           ),
                                       );
                                     }
                                     );
                                    } else if (userSnapshot.hasError) {
                                      return Text('Error: ${userSnapshot.error}');
                                    }
                                    return const Center(
                                      child: Text("Nothing  here"),
                                    );
                                  },
                                );
                              },
                            );
                          } else if (snapshot.hasError) {
                            return Center(child: Text('Error: ${snapshot.error}'));
                          }
                          return const Center();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
