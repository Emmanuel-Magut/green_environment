import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:green_environment/GreenCommunity/comment.dart';
import 'package:green_environment/GreenCommunity/like_button.dart';
import '../DateTimeFormat/date_time.dart';
import '../services/chatting_page.dart';
import 'delete_posts_button.dart';
 class WallPosts extends StatefulWidget {

   final Function()? onTap;
   final String message;
   final String user;
   final String time;
   final String image;
   final String userEmail;
   final String profession;
   final String id;
   final String commentId;
   final String postImage;

   //likes

   //id is the postId
   final List<String> likes; //contains emails of all the users that liked it
   const WallPosts({
     super.key,
     required this.postImage,
     required this.commentId,
     required this.id,
     required this.message,
     required this.user,
     required this.time,
     required this.likes,
     required this.image,
     required this.userEmail,
     required this.profession,
    required  this.onTap,

   });

  @override
  State<WallPosts> createState() => _WallPostsState();
}

class _WallPostsState extends State<WallPosts> {
   //show mmore or less comments
  int maxCommentsToShow = 5;
  bool showAllComments = false;
//hide add comments button
  bool showAddCommentContainer = false;
  void toggleAddCommentContainer() {
    setState(() {
      showAddCommentContainer = !showAddCommentContainer;
    });
  }
   //get user fro firebase
final currentUser = FirebaseAuth.instance.currentUser!;
bool isLiked = false;
final _commentTextController = TextEditingController();
@override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser.email);
  }
  //toggle between like and unlike
  void toggleLike(){
  setState((){
    isLiked = !isLiked;
  });
   //Access the document in firebase

    DocumentReference postRef =
        FirebaseFirestore.instance.collection('Posts').doc(widget.id);
    if(isLiked){
      //if the post is now liked, add the user's email to the 'likes' field
     postRef.update({
       'Likes': FieldValue.arrayUnion([currentUser.email]),
     });
    }else{
      //if the post is now unliked, remove the user's email from the likes field
     postRef.update({
       'Likes': FieldValue.arrayRemove([currentUser.email]),
     });
    }

  }



  //add a comment
void addComment(String commentText){
  //write the comments to firestore under the comments collection for the post
  FirebaseFirestore.instance
      .collection('Posts')
      .doc(widget.id)
      .collection("comments")
      .add({
       'commentText': commentText,
       'commentedBy': currentUser.email,
       'commentTime': Timestamp.now(),
  });

}

Future<void> totalComments(String id) async {
  try {
    // Reference to the comments collection for the specific post
    CollectionReference commentsCollection = FirebaseFirestore.instance
        .collection('Posts')
        .doc(widget.id)
        .collection("comments");

    // Fetch the documents (comments) from the collection
    QuerySnapshot querySnapshot = await commentsCollection.get();

    // Get the total number of comments
    int totalComments = querySnapshot.size;

  } catch (error) {
    print('Error fetching total comments: $error');
    // Handle errors as needed
  }
}


  //show a dialog box for adding comment
  void showCommentDialog(){
  showDialog(context: context, builder: (context) => AlertDialog(
      title: const Text("Add Comment"),
    content: TextField(
     controller: _commentTextController,
      decoration: const InputDecoration(
        hintText: "Write a comment...",
      ),
    ),
    actions:  [

      //cancel button
      TextButton(onPressed:(){
        //pop the box
        Navigator.pop(context);
        // clear controller
        _commentTextController.clear();
        },
        child: const Text("Cancel"),
      ),

      TextButton(onPressed:() {
        addComment(_commentTextController.text);
        //clear controller
        _commentTextController.clear();
        //pop the box
        Navigator.pop(context);
        },
        child: const Text("Comment"),
      ),
    ],
  ),
  );
}

//deletePost
  void deletePost(){
  //delete confirmation dialog box
    showDialog(context: context, builder: (context) => AlertDialog(
      title: const Text("Delete this Post"),
      content: const Text("Are you sure you want to delete this post?"),
      actions: [
        //CANCEL BUTTON
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
        ),
        //DELETE BUTTON
        TextButton(
          onPressed: () async {
            //delete replies first
            final repliesDoc = await FirebaseFirestore.instance
                   .collection("Posts")
                   .doc(widget.id)
                   .collection("comments")
                   .doc(widget.commentId)
                   .collection("replies")
                   .get();
            for(var docs in repliesDoc.docs){
              await FirebaseFirestore.instance
                  .collection("Posts")
                  .doc(widget.id)
                  .collection("comments")
                  .doc(widget.commentId)
                  .collection("replies")
                  .doc(docs.id)
                  .delete();
            }

         //then delete the comments from firestore. deleting the post alone, you still have comments eating storage
            final commentDocs = await FirebaseFirestore.instance
                .collection("Posts")
                .doc(widget.id)
                .collection("comments")
                .get();
            for(var doc in commentDocs.docs){
              await FirebaseFirestore.instance
                  .collection("Posts")
                  .doc(widget.id)
                  .collection("comments")
                  .doc(doc.id)
                  .delete();
            }
            //then delete the post
            FirebaseFirestore.instance
                .collection("Posts")
                .doc(widget.id)
                .delete()
                .then((value) => print("Post Deleted"))
                .catchError(
                    (error) => print("Failed to delete post: $error"));
//close the dialog box
          Navigator.pop(context);
            },
          child: const Text("Delete"),
        ),
      ],
    ),
    );

  }
   @override
   Widget build(BuildContext context) {
     return Container(
       margin: const EdgeInsets.only(top:6,bottom: 6),
       decoration:  const BoxDecoration(
         color:Colors.white,
       ),
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Row(
                 children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, top: 10),
                    child: GestureDetector(
                     onTap: widget.onTap,
                      child: ClipOval(
                         child: Image.network(
                           widget.image,
                           width: 50,
                           height: 50,
                           fit: BoxFit.cover,
                         ),
                      ),
                    ),
                  ) ,
                   const SizedBox(width:10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Row(
                              children: [
                                Text(widget.user,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight:FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 40),
                                Text(widget.time,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight:FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Text(widget.profession,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                        ],
                      ),


                    ],
                  ),
                   const SizedBox(width: 100),
                   //delete button
                   if(widget.userEmail == currentUser.email)
                     DeleteButton(onTap:deletePost),
                 ],
               ),

               const SizedBox(height: 10),
               Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: Text(widget.message,
                   style: const TextStyle(
                     fontSize: 17,
                   ),
                 ),
               ),
             ],
           ),
       Container(
         width: MediaQuery.of(context).size.width,
         child: widget.postImage != null
             ? (widget.postImage.startsWith('http')
             ? Image.network(
           widget.postImage,
           width: MediaQuery.of(context).size.width,
           fit: BoxFit.cover,
           errorBuilder: (context, error, stackTrace) => SizedBox(), // Return null for errors
         )
             : Image.network(
           widget.postImage, // Use the path directly for local images
           width: MediaQuery.of(context).size.width,
           fit: BoxFit.cover,
           errorBuilder: (context, error, stackTrace) => SizedBox(), // Return null for errors
         ))
             : SizedBox(),
       ),



           const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
               Container(
                 padding: const EdgeInsets.only(left: 18, right:18),
                 decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(14),
                   border: Border.all(
                     color: Colors.green.shade200,
                   )

                 ),
                 child:  Row(
                   children: [
                     LikeButton(isLiked: isLiked,
                       onTap: toggleLike,
                     ),

                     //like count
                     Text("${widget.likes.length} likes",
                       style: const TextStyle(
                         color:Colors.grey,
                         fontWeight: FontWeight.bold,
                         fontSize: 15,
                       ),
                     ),
                   ],
                 ),
               ),
                Container(
                  padding: const EdgeInsets.only(left:18, right:18),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.green.shade200,
                      )
                  ),
                  child:

                   GestureDetector(
                     onTap: () {
                       toggleAddCommentContainer(); // Toggle the visibility
                     },
                     child:  const Row(
                      children: [
                        Icon(Icons.comment,
                          size: 25,
                          color: Colors.green,
                        ),
                        SizedBox(width: 4),
                        Text("Comments"),
                      ],
                     ),
                   ),
                ),
              ],
            ),
          ),
           //comment box
           const SizedBox(height: 10),
           //comments
           if (showAddCommentContainer)
             StreamBuilder<QuerySnapshot>(
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

                 // Get all comments
                 List<DocumentSnapshot> allComments = snapshot.data!.docs;

                 // Filter comments based on whether to show all or just a few
                 List<DocumentSnapshot> commentsToShow = showAllComments
                     ? allComments
                     : allComments.take(maxCommentsToShow).toList();

                 return Column(
                   children: [
                     ListView(
                       shrinkWrap: true, // for nested lists
                       physics: const NeverScrollableScrollPhysics(),
                       children: commentsToShow.map((doc) {
                         // Get comments
                         final commentData = doc.data() as Map<String, dynamic>;

                         String email = commentData['commentedBy'];
                         Stream<QuerySnapshot> userStream =
                         FirebaseFirestore.instance
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
                                 username = userSnapshot.data!.docs[0].get("username");
                                 image = userSnapshot.data!.docs[0].get("profileImage");
                                 uid = userSnapshot.data!.docs[0].get("uid");
                                 email = userSnapshot.data!.docs[0].get("email");
                               }
                               return Comments(
                                 id:widget.id,
                                 commentId: doc.id,
                                 text: commentData['commentText'],
                                 user: username,
                                 email: email, // use username instead of email
                                 image: image,
                                 time: formatDate(commentData['commentTime']),
                                 onTap: () async {
                                   showDialog(
                                     context: context,
                                     builder: (context) => AlertDialog(
                                       title: Text(username),
                                       content: Column(
                                         mainAxisSize: MainAxisSize.min,
                                         children: [
                                           CircleAvatar(
                                             radius: 38,
                                             backgroundImage: NetworkImage(image),
                                           ),
                                           const SizedBox(height: 10),
                                           Text(username),
                                         ],
                                       ),
                                       actions: [
                                         TextButton(
                                           onPressed: () => Navigator.pop(context),
                                           child: const Text("Close"),
                                         ),
                                         TextButton(
                                           onPressed: () {
                                             Navigator.push(
                                               context,
                                               MaterialPageRoute(
                                                 builder: (context) => ChattingPage(
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
               },
             ),
           if (showAddCommentContainer)
           Padding(
             padding: const EdgeInsets.only(top:10, bottom: 10, left: 20, right: 20),
             child: Container(
               padding: const EdgeInsets.only(bottom: 15,left:10, right:10, top: 15),
               decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(20),
                   border: Border.all(
                     color: Colors.green.shade200,
                   )
               ),
               child:  Center(child: GestureDetector(
                 onTap: showCommentDialog,
                 child: const Text("Add Comments",
                 style: TextStyle(
                   fontSize: 16,
                   color: Colors.grey,
                   fontWeight: FontWeight.bold,
                 ),
                 ),
               ),
               ),
             ),
           ),
         ],
       ),
     );
   }
}
 