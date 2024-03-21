import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:green_environment/events/post_events_page.dart';
import 'package:green_environment/pages/notifications.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class TreePlantingEvents extends StatefulWidget {
  const TreePlantingEvents({Key? key}) : super(key: key);

  @override
  State<TreePlantingEvents> createState() => _TreePlantingEventsState();
}

class _TreePlantingEventsState extends State<TreePlantingEvents> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool _isMenuOpen = false;

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });
  }

  //RSVP
  void rSVP(String eventId) {
    //delete confirmation dialog box
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Attendance"),
        content: const Text("Will You attend this Tree Planting Event?"),
        actions: [
          //CANCEL BUTTON
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text("No",
                style:TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          //YES BUTTON
          TextButton(
            onPressed: () async {
              const CircularProgressIndicator();
              // Fetch the event document using the eventId
              DocumentSnapshot eventDocument = await FirebaseFirestore.instance.collection('upcoming_events').doc(eventId).get();
              if (eventDocument.exists) {
                // Add currentUser.email to attendees list
                await FirebaseFirestore.instance.collection('upcoming_events').doc(eventId).update({
                  'attendees': FieldValue.arrayUnion([currentUser.email])
                });
              } else {
                print("Event document not found!");
              }
              Navigator.pop(context);
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(12),
              ),
                child: const Text("Yes",
                style:TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
                ),
            ),
          ),
        ],
      ),
    );
  }
  //Cancel RSVP
  void cancelRSVP(String eventId) {
    //delete confirmation dialog box
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Image.asset("lib/images/sad.png",
        height: 60,
        ),
        content: const Text("Are You sure you want to cancel your attendance?",
        style: TextStyle(
          fontSize: 18,
        ),
        ),
        actions: [
          //CANCEL BUTTON
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text("No",
                style:TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          //YES BUTTON
          TextButton(
            onPressed: () async {
              const CircularProgressIndicator();
              // Fetch the event document using the eventId
              DocumentSnapshot eventDocument = await FirebaseFirestore.instance.collection('upcoming_events').doc(eventId).get();
              if (eventDocument.exists) {
                // remove currentUser.email from attendees list
                await FirebaseFirestore.instance.collection('upcoming_events').doc(eventId).update({
                  'attendees': FieldValue.arrayRemove([currentUser.email])
                });
              } else {
                print("Event document not found!");
              }
              Navigator.pop(context);
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text("Yes",
                style:TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
//cancel event
  void cancelPlantingEvent(String eventId) {
    //delete confirmation dialog box
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Cancel Event"),
        content: const Text("Are You Sure You Want to Cancel This Event?"),
        actions: [
          //CANCEL BUTTON
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text("No",
                style:TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          //YES BUTTON
          TextButton(
            onPressed: () async {
              const CircularProgressIndicator();
              // Fetch the event document using the eventId
              DocumentSnapshot eventDocument = await FirebaseFirestore.instance.collection('upcoming_events').doc(eventId).get();
              if (eventDocument.exists) {
                // Add currentUser.email to attendees list
                await FirebaseFirestore.instance.collection('upcoming_events').doc(eventId).update({
                  'event_status': "Cancelled"
                });
              } else {
                print("Event document not found!");
              }
              Navigator.pop(context);
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text("Yes",
                style:TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //Close the event
  void closeEvent(String eventId) {
    String remarks = '';
    int treesPlanted = 0;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Close The Event"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                maxLines: 2,
                cursorColor: Colors.green,

                decoration: const InputDecoration(
                    labelText: 'Remarks',
                ),
                onChanged: (value) {
                  remarks = value;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Number of Trees Planted'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  treesPlanted = int.tryParse(value) ?? 0;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              if (remarks.isEmpty || treesPlanted == 0) {
                // Show error message if fields are empty
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill all the fields')
                    )
                );
                return;
              }

              // Update database
              await FirebaseFirestore.instance.collection('upcoming_events').doc(eventId).update({
                'remarks': remarks,
                'total_trees_planted': treesPlanted,
                'event_status': "Closed"
              });

              Navigator.pop(context); // Close the dialog
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "Close",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Tree Planting Events",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: "Literata",
            ),
          ),
          backgroundColor: Colors.green,
        ),
        body:_buildTreePlantingEvents(currentUser.email!),
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.menu),
                onPressed: _toggleMenu,
              ),
              IconButton(
                icon: Stack(
                  children: [
                    const Icon(Icons.notifications,
                    size: 30,
                      color: Colors.green,
                    ),
                    FutureBuilder<int>(
                      future: getUnreadNotificationCount(currentUser.email ?? ''),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Container(); // Return a loading indicator or placeholder widget
                        } else if (snapshot.hasError) {
                          return Container(); // Return an error widget
                        } else {
                          int unreadCount = snapshot.data ?? 0;
                          return unreadCount > 0
                              ? Positioned(
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 16,
                                minHeight: 16,
                              ),
                              child: Text(
                                '$unreadCount',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                              : Container(); // Return an empty container if unreadCount is 0
                        }
                      },
                    ),

                  ],
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Notifications())
                    
                  );
                },
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>const PostEventPage(),
              ),
            );
          },
          child: const Column(
            children: [
              Icon(Icons.add,
              color: Colors.green,
              ),
              Text("Add Event",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        extendBody: true,
        bottomSheet: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          height: _isMenuOpen ? 250 : 0,
          child: GestureDetector(
            onTap: _toggleMenu,
            child: Container(
              color: Colors.grey[200],
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //shedule notifications to be sent to users
                    if ( currentUser.email == 'ekiplimo38@gmail.com')
                    GestureDetector(
                      onTap: () => sendNotificationForTomorrowEvents(context), // Call the function with context
                      child: Container(
                        padding: const EdgeInsets.only(left: 5,right: 5, top: 5, bottom: 5),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text("Send Notifications",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),


                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTreePlantingEvents(String currentUserEmail) {
    return FutureBuilder<String>(
      future: _fetchUserLocationCounty(),
      builder: (context, userCountySnapshot) {
        if (userCountySnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.green,
            ),
          );
        } else if (userCountySnapshot.hasError) {
          return Text('Error fetching user county');
        }

        final userCounty = userCountySnapshot.data ?? '';

        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('upcoming_events')
              .where('county', isEqualTo: userCounty)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.green,
                ),
              );
            }

            return ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return _buildTreeEventsGridItem(snapshot.data!.docs[index]);
              },
            );
          },
        );
      },
    );
  }

  //fetch location
  Future<String> _fetchUserLocationCounty() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks =
      await placemarkFromCoordinates(position.latitude, position.longitude);

      // Extract the county name from the retrieved placemark
      String userCounty = placemarks.first.administrativeArea ?? "Unknown";
      userCounty = userCounty.replaceAll(" County", "");

      // Debug by printing the retrieved county name:
      print("Retrieves county name: $userCounty");

      return userCounty;
    } catch (e) {
      print('Error fetching user county: $e');
      return ''; // Return empty string if an error occurs
    }
  }



  Widget _buildTreeEventsGridItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: const EdgeInsets.only(top: 20,bottom: 20,right: 10,left: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.green,
              width: 2,
            )
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 5, right: 5,
            bottom: 20, top:20),
            child: Column(
              children: <Widget>[
                if ( _isToday(data['date']) && data['event_status'] != 'Cancelled')
                 Column(
                  children: [
                     const Text("Hello, Today is the event date",
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: "Pacifico",
                      letterSpacing: 2,
                    ),
                    ),
                    Image.asset("lib/images/plantingday.png",
                    height: 100,
                    ),
                  ],
                ),


                Text(
                  data['title'] ?? '',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    fontFamily: 'Literata',
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 300,
                  width: MediaQuery.of(context).size.width,
                  child: data['imageUrl'] != null && data['imageUrl'] != ''
                      ? Image.network(
                    data['imageUrl'],
                    width: MediaQuery.of(context).size.width,
                    height: 300,
                    fit: BoxFit.cover,
                  )
                      : Container(
                    height: 150,
                    width: MediaQuery.of(context).size.width,
                    child: Image.asset('lib/images/go1.jpeg',
                      width: MediaQuery.of(context).size.width,
                      height: 120,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Column(
                  children: [
                     const Text("Event Description:",
                     style:TextStyle(
                       fontSize: 18,
                       fontWeight: FontWeight.bold,
                     )
                     ),
                    Text(
                      data['description'] ?? '',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                 const SizedBox(height: 10),
                 Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          const Text("Date:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          ),
                          const SizedBox(width:5 ,),
                          Text(
                            DateFormat('y MMMM d').format((data['date'] as Timestamp).toDate()),
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),

                      Row(
                        children: [
                          const Text("Venue:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(width:5 ,),
                          Text(
                            data['location'] ?? '',
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),

                    ],
                               ),
                 ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          const Text("Contact:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(width:5 ,),
                          Text(
                            data['phone'] != null ? data['phone'].toString() : '',
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),

                        ],
                      ),

                      Row(
                        children: [
                          const Text("Status:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(width:5 ,),
                          Text(
                            data['event_status'] ?? '',
                            style: TextStyle(
                              fontSize: 16,
                              color: _getStatusColor(data['event_status']),
                            ),
                          ),

                        ],
                      ),
                    ],
                  ),
                ),

                Row(
                  children: [
                    const Text("County:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(width:5 ,),
                    Text(
                      data['county'] ?? '',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                 const SizedBox(height: 10),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     if( data['event_status'] != 'Cancelled')

                     Row(
                       children: [
                         const Text("Attendees:",
                           style: TextStyle(
                             fontWeight: FontWeight.bold,
                             fontSize: 18,
                           ),
                         ),
                         Text(
                           ' ${((data['attendees'] ?? []) as List<dynamic>).length}',
                           style: const TextStyle(
                             fontSize: 16,
                           ),
                         ),

                       ],
                     ),
                     if( data['email']== currentUser.email && data['event_status'] != 'Cancelled' && data['event_status'] != 'Closed')
                       GestureDetector(
                         onTap:() =>cancelPlantingEvent(document.id),
                         child: const Icon(Icons.delete,
                         color: Colors.red,
                         ),
                       ),
                   ],
                 ),
                const SizedBox(height: 10),
                if(data['event_status'] == 'Closed')
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Remarks:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        if( data['email']== currentUser.email &&  data['event_status'] == 'Closed')
                          GestureDetector(
                            onTap:() =>closeEvent(document.id),
                            child: const Icon(Icons.edit,
                              color: Colors.grey,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width:5 ,),
                    Text(
                      data['remarks'] ?? '',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                     //trees planted
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Text("Trees Planted:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(width:5 ,),
                        Text(
                          '${data['total_trees_planted'] ?? ''}',
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),


                  ],
                ),
                //remind user that he/she will be attending the event
                if(
                    (data['attendees'] ?? []).contains(currentUser.email)
                        && data['event_status'] != 'Closed'
                        && data['event_status'] != 'Cancelled'
                )
                 Column(
                  children: [
                    const Text("You are among the event attendees!",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    ),
                     const SizedBox(height:8),
                     GestureDetector(
                       onTap: () => cancelRSVP(document.id),
                       child: const Text("Cancel attendance anytime",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                       ),
                     ),
                  ],
                ),

                const SizedBox(height: 2),
                if( data['event_status'] != 'Cancelled'
                    && data['event_status'] != 'Pending'
                    && data['event_status'] != 'Closed'
                    && data['email'] != currentUser.email
                    &&
                    !(data['attendees'] ?? []).contains(currentUser.email)
                    && !_isPastEvent(data['date'])
                )
                  GestureDetector(
                  onTap: () => rSVP(document.id),
                  child: Container(
                    padding: const EdgeInsets.only(left: 10,right: 10, top: 10, bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text("R.S.V.P this event",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 18,
                    ),
                    ),
                  ),
                ),
                //close event if it is only the exact date
                if (data['email'] == currentUser.email &&
                    (_isToday(data['date']) || _isPastEvent(data['date'])) &&
                    data['event_status'] != 'Cancelled' &&
                    data['event_status'] != 'Closed'   &&
                     data['event_status'] != 'Pending')

                  Column(
                    children: [
                      GestureDetector(
                        onTap: () => closeEvent(document.id),
                        child: Container(
                          padding: const EdgeInsets.only(left: 10,right: 10, top: 10, bottom: 10),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text("Close The Event",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

              ],
            ),
          ),
        ),
      );
    }
    //status color
  Color _getStatusColor(String? status) {
    switch (status) {
      case 'Pending':
        return Colors.pink;
      case 'Approved':
        return Colors.blue;
      case 'Cancelled':
        return Colors.red;
      case 'Closed':
        return Colors.orange;
      default:
        return Colors.black; // Default color if status is not recognized
    }
  }

  // Check if the event is past
  bool _isPastEvent(Timestamp eventDate) {
    final now = DateTime.now();
    final eventDateTime = eventDate.toDate(); // Convert Timestamp to DateTime
    return now.isAfter(eventDateTime);
  }

// Function to check if the date is today
  bool _isToday(Timestamp? date) {
    if (date != null) {
      DateTime eventDate = date.toDate();
      DateTime currentDate = DateTime.now();
      return eventDate.year == currentDate.year &&
          eventDate.month == currentDate.month &&
          eventDate.day == currentDate.day;
    }
    return false;
  }

  Future<void> sendNotificationForTomorrowEvents(BuildContext context) async {
    try {
      // Show circular progress indicator while sending notifications
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Sending notifications...'),
              ],
            ),
          );
        },
      );

      // Get the current date and tomorrow's date
      DateTime currentDate = DateTime.now();
      DateTime tomorrowDate = DateTime(currentDate.year, currentDate.month, currentDate.day + 1);

      // Query upcoming events scheduled for tomorrow
      QuerySnapshot upcomingEventsSnapshot = await FirebaseFirestore.instance
          .collection('upcoming_events')
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(tomorrowDate))
          .where('date', isLessThan: Timestamp.fromDate(tomorrowDate.add(const Duration(days: 1))))
          .get();

      // Iterate through the upcoming events scheduled for tomorrow
      for (DocumentSnapshot eventDocument in upcomingEventsSnapshot.docs) {
        // Get the event data
        Map<String, dynamic>? eventData = eventDocument.data() as Map<String, dynamic>?;

        // Check if eventData is not null before proceeding
        if (eventData != null) {
          // Construct notification message
          String title = 'Tomorrow is Tree Planting Day!';
          String body = 'Get ready for the ${eventData['title']} event tomorrow!';
          String eventId = eventDocument.id;

          // Update notifications for each attendee
          List<dynamic> attendees = eventData['attendees'];
          for (var attendeeEmail in attendees) {
            // Check if the notification for this event has already been sent to the user
            DocumentSnapshot userNotificationsDoc = await FirebaseFirestore.instance
                .collection('notifications')
                .doc(attendeeEmail)
                .get();

            // Check if the document exists and if the notification for this event has already been sent
            if (userNotificationsDoc.exists) {
              List<dynamic>? notifications;
              final userData = userNotificationsDoc.data();
              if (userData is Map<String, dynamic>) {
                notifications = userData['notifications'] as List<dynamic>?;
              }

              bool notificationExists = notifications != null && notifications.any((notification) => notification['eventId'] == eventId);

              if (notificationExists) {
                // Skip adding notification as it already exists for this event and user
                continue;
              }
            }

            // Create or update a document for the user in the "notifications" collection
            DocumentReference userRef = FirebaseFirestore.instance.collection('notifications').doc(attendeeEmail);
            await userRef.set({
              'email': attendeeEmail,
              'notifications': FieldValue.arrayUnion([
                {
                  'timestamp': Timestamp.now(),
                  'title': title,
                  'body': body,
                  'eventId': eventId,
                  'read': false,
                },
              ]),
            }, SetOptions(merge: true)); // Merge option to update existing document
          }
        }
      }

      // Close the progress indicator and show success message
      Navigator.pop(context); // Close the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text('Notifications sent successfully!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the success dialog
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (error) {
      print('Error sending notifications: $error');
      // Close the progress indicator and show error message
      Navigator.pop(context); // Close the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text('Error sending notifications: $error'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the error dialog
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }


  Future<int> getUnreadNotificationCount(String userEmail) async {
    try {
      // Retrieve the user document
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('notifications')
          .doc(userEmail)
          .get();

      // Check if the user document exists and contains notifications
      if (userDoc.exists) {
        // Get the user document data as Map<String, dynamic>
        Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;

        // Check if userData is not null and contains notifications field
        if (userData != null && userData.containsKey('notifications')) {
          // Get the notifications array
          List<dynamic>? notifications = userData['notifications'];

          // If notifications exist, count the unread ones
          if (notifications != null) {
            int unreadCount = notifications.where((notification) => notification['read'] == false).length;
            // Print the total count to the console
            print('Total unread notifications count for $userEmail: $unreadCount');
            return unreadCount;
          }
        }
      }

      // If user document or notifications array doesn't exist, return 0
      return 0;
    } catch (error) {
      // Handle error
      print('Error getting unread notification count: $error');
      return 0; // Return 0 if there's an error
    }
  }









}
