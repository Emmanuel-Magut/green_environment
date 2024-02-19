

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:green_environment/GreenCommunity/posts.dart';

class WallPostsState extends State<WallPosts> {

  int maxCommentsToShow = 5;
  bool showAllComments = false;

  Widget buildCommentsSection(List<DocumentSnapshot> allComments) {
    List<DocumentSnapshot> commentsToShow = showAllComments
        ? allComments
        : allComments.take(maxCommentsToShow).toList();

    return Column(
      children: [
        // Display comments
        ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: commentsToShow.map((doc) {
            // Get comments
            final commentData = doc.data() as Map<String, dynamic>;
            String email = commentData['commentedBy'];

            // ... existing code ...

            return Container(); // Placeholder for your Comments widget
          }).toList(),
        ),
        if (allComments.length > maxCommentsToShow)
          TextButton(
            onPressed: () {
              setState(() {
                showAllComments = !showAllComments;
              });
            },
            child: Text(
              showAllComments ? "Show less" : "Show more",
              style: const TextStyle(color: Colors.blue),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child:  StreamBuilder<QuerySnapshot>(
       stream: FirebaseFirestore.instance
           .collection('Posts')
           .doc(widget.id)
           .collection("comments")
           .orderBy("commentTime", descending: false)
           .snapshots(),
       builder: (context, snapshot) {
         // Show loading circle if no data yet
         if (!snapshot.hasData) {
           return const Center();
         }

         List<DocumentSnapshot> allComments = snapshot.data!.docs;
         return buildCommentsSection(allComments);
       },
     ),

    );
  }
}
