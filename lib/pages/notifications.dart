import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final currentUser = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications",
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        ),
        backgroundColor: Colors.green,
      ),
     body: _buildNotificationsGrid(),
    );
  }

  Widget _buildNotificationsGrid() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('notifications').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            return _buildNotificationsGridItem(snapshot.data!.docs[index]);
          },
        );
      },
    );
  }

  Widget _buildNotificationsGridItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
    if (FirebaseAuth.instance.currentUser?.email == data['email']) {
      List<dynamic> notifications = data['notifications'];
      if (notifications != null && notifications.isNotEmpty) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            const SizedBox(height: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: notifications.map((notification) {
                Color backgroundColor = notification['read'] ? Colors.white : Colors.green.shade100;
                return Padding(
                  padding: const EdgeInsets.only(left: 0, right: 0),
                  child: GestureDetector(
                    onTap: () => readNotification(currentUser.email!,notification['body']),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        border: Border.all(
                          color: Colors.green,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                notification['title'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            const SizedBox(width: 10),
                            if(notification['read'] == false )
                              Image.asset('lib/images/new.png',
                                height: 25,
                              )
                            ],
                          ),
                          Text(
                            notification['body'],
                            style: const TextStyle(
                              fontSize: 17,
                            ),
                          ),
                          const SizedBox(height: 5),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        );
      } else {
        return Container(); // Return an empty container if there are no notifications
      }
    } else {
      return Container();
    }
  }
//read notifications
  Future<void> readNotification(String userEmail, String notificationBody) async {
    try {
      // Get the document reference for the user's notifications
      DocumentReference userNotificationsRef = FirebaseFirestore.instance
          .collection('notifications')
          .doc(userEmail);

      // Get the document snapshot for the user's notifications
      DocumentSnapshot userNotificationsDoc = await userNotificationsRef.get();

      // Check if the document exists
      if (userNotificationsDoc.exists) {
        // Get the notifications list from the user's document
        Map<String, dynamic>? data = userNotificationsDoc.data() as Map<String, dynamic>?;

        if (data != null) {
          List<dynamic> notifications = data['notifications'];

          // Find the notification with the given title
          int index = notifications.indexWhere((notification) => notification['body'] == notificationBody);

          // If the notification exists, mark it as read
          if (index != -1) {
            notifications[index]['read'] = true;

            // Update the notifications list in the user's document
            await userNotificationsRef.update({'notifications': notifications});
          } else {
            print('Notification with title "$notificationBody" not found.');
          }
        }
      } else {
        print('User document for email "$userEmail" not found.');
      }
    } catch (error) {
      print('Error updating notification read status: $error');
      // Handle error gracefully
    }
  }





}


