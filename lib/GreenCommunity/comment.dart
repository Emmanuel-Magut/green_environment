import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../DateTimeFormat/date_time.dart';
import '../services/chatting_page.dart';
import '1_replies.dart';
import 'delete_comment.dart';

class Comments extends StatefulWidget {
  final String id; // doc id
  final String text;
  final String user;
  final String time;
  final String image;
  final String email;
  final String commentId;
  final Function()? onTap;

  const Comments({
    super.key,
    required this.id,
    required this.text,
    required this.user,
    required this.time,
    required this.image,
    required this.onTap,
    required this.email,
    required this.commentId,
  });

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  final _reply1TextController = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser!;

  int maxRepliesToShow = 1;
  bool showAllReplies = false;
  bool showAddCommentContainer = false;
  bool showDeleteButton = false;

  @override
  void initState() {
    super.initState();
  }

  void toggleShowReplies() {
    setState(() {
      showAllReplies = !showAllReplies;
    });
  }

  void repliesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Reply"),
        content: TextField(
          controller: _reply1TextController,
          decoration: const InputDecoration(
            hintText: "Reply ...",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _reply1TextController.clear();
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              addReplies(_reply1TextController.text);
              _reply1TextController.clear();
              Navigator.pop(context);
            },
            child: const Text("Comment"),
          ),
        ],
      ),
    );
  }

  void addReplies(String replyText) {
    FirebaseFirestore.instance
        .collection('Posts')
        .doc(widget.id)
        .collection("comments")
        .doc(widget.commentId)
        .collection("replies")
        .add({
      'replyText': replyText,
      'repliedBy': currentUser.email,
      'replyTime': Timestamp.now(),
    });
  }

  Future<void> deleteComment() async {
    final repliesDoc = await FirebaseFirestore.instance
        .collection("Posts")
        .doc(widget.id)
        .collection("comments")
        .doc(widget.commentId)
        .collection("replies")
        .get();

    for (var docs in repliesDoc.docs) {
      await FirebaseFirestore.instance
          .collection("Posts")
          .doc(widget.id)
          .collection("comments")
          .doc(widget.commentId)
          .collection("replies")
          .doc(docs.id)
          .delete();
    }

    await FirebaseFirestore.instance
        .collection("Posts")
        .doc(widget.id)
        .collection("comments")
        .doc(widget.commentId)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        setState(() {
          showDeleteButton = !showDeleteButton;
        });
      },
      child: Container(
        padding: const EdgeInsets.only(left: 8, bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 2),
                  child: GestureDetector(
                    onTap: widget.onTap,
                    child: ClipOval(
                      child: Image.network(
                        widget.image,
                        width: 35,
                        height: 35,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  widget.user,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        widget.text,
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(width: 20),
                      if (widget.email == currentUser.email && showDeleteButton)
                        Row(
                          children: [
                            DeleteComment(onTap: deleteComment),
                            const SizedBox(width: 10),
                            IconButton(onPressed: (){

                              setState(() {
                                showDeleteButton = !showDeleteButton;
                              });
                            }, icon: const Icon(Icons.close_sharp,
                              color: Colors.red,

                            ),

                            ),
                          ],
                        ),


                    ],
                  ),

                  const SizedBox(width: 10),
                  Row(
                    children: [
                      Text(
                        widget.time,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: repliesDialog,
                        child: Text(
                          "Reply",
                          style:  TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Posts')
                  .doc(widget.id)
                  .collection("comments")
                  .doc(widget.commentId)
                  .collection('replies')
                  .orderBy("replyTime", descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center();
                }

                List<DocumentSnapshot> allReplies = snapshot.data!.docs;
                List<DocumentSnapshot> repliesToShow = showAllReplies
                    ? allReplies
                    : allReplies.take(maxRepliesToShow).toList();

                return Column(
                  children: [
                    ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: repliesToShow.map((doc) {
                        final repliesData =
                        doc.data() as Map<String, dynamic>;
                        String email = repliesData['repliedBy'];
                        Stream<QuerySnapshot> userStream = FirebaseFirestore
                            .instance
                            .collection("users")
                            .where("email", isEqualTo: email)
                            .snapshots();

                        return StreamBuilder<QuerySnapshot>(
                          stream: userStream,
                          builder: (context, userSnapshot) {
                            if (userSnapshot.hasData) {
                              String username = "";
                              String image = "";
                              String uid = "";
                              if (userSnapshot.data!.docs.isNotEmpty) {
                                username =
                                    userSnapshot.data!.docs[0].get("username");
                                image =
                                    userSnapshot.data!.docs[0].get("profileImage");
                                uid = userSnapshot.data!.docs[0].get("uid");
                                email = userSnapshot.data!.docs[0].get("email");
                              }
                              return Replies(
                                text: repliesData['replyText'],
                                user: username,
                                email: email,
                                image: image,
                                time: formatDate(repliesData['replyTime']),
                                onTap: () async {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text(username),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CircleAvatar(
                                            radius: 32,
                                            backgroundImage:
                                            NetworkImage(image),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(username),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text("Close"),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ChattingPage(
                                                      receiverUserEmail: email,
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
                                },
                              );
                            } else if (userSnapshot.hasError) {
                              return Text('Error: ${userSnapshot.error}');
                            }
                            return const Center();
                          },
                        );
                      }).toList(),
                    ),
                    if (allReplies.length > maxRepliesToShow)
                      TextButton(
                        onPressed: () {
                          setState(() {
                            showAllReplies = !showAllReplies;
                          });
                        },
                        child: Text(
                          showAllReplies
                              ? "Show less"
                              : "Show more replies",
                          style: const TextStyle(color: Colors.blue),
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
