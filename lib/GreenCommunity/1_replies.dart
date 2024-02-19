import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Replies extends StatefulWidget {
  final String text;
  final String user;
  final String time;
  final String image;
  final String email;
  final Function()? onTap;
  const Replies({super.key,

    required this.text,
    required this.user,
    required this.time,
    required this.image,
    required this.onTap,
    required this.email,
  });

  String? get id => null;

  String? get commentId => null;

  @override
  State<Replies> createState() => _RepliesState();
}

class _RepliesState extends State<Replies> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool showDeleteButton = false;
  @override
  void initState() {
    super.initState();
  }

  Future<void> deleteReply() async {
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
        padding: const EdgeInsets.only(left: 20, bottom:2),
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
                        width: 20,
                        height: 20,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ) ,
                const SizedBox(width: 8),
                Text(widget.user,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),

              ],
            ),


            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.text,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),

                  const SizedBox(width:10),
                  Text(widget.time,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 20),
                  if (widget.email == currentUser.email && showDeleteButton)
                    IconButton(onPressed: deleteReply, icon: Icon(Icons.delete)),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}



