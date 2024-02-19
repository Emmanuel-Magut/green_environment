import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:green_environment/GreenCommunity/green_community.dart';
import 'package:green_environment/sections/nba.dart';
import 'package:provider/provider.dart';

import '../models/news.dart';
import '../profile_page.dart';
import '../services/auth_service.dart';
import '../services/chat_page.dart';
import '../services/profile_picture.dart';
import 'home.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  void logout() {
    FirebaseAuth.instance.signOut();
  }

  final user = FirebaseAuth.instance.currentUser!;


  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    Home(),
    Text('Donate'),
    Text('Notifications'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          'Twende Green',
          style: TextStyle(
            fontSize: 30,
            fontFamily: 'Lobster',
            color: Colors.white,

          ),
        ),
      ),
      backgroundColor: Colors.white,
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              child: Column(
                children: [
                  FutureBuilder<DocumentSnapshot>(
                    future: _firestore.collection('users').doc(user.uid).get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data == null || !snapshot.data!.exists) {
                        return Text('No data for the user');
                      } else {
                        var userData = snapshot.data!.data() as Map<String, dynamic>;
                        var profileImageUrl = userData['profileImage'] as String?;
                        var username = userData['username'] as String?;
                        return profileImageUrl != null
                            ? GestureDetector(
                          onTap: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context)=> ProfilePicturePage())
                            );
                          },
                              child: ClipOval(
                                child: Image.network(
                              profileImageUrl,
                              width: 90,
                              height: 90,
                              fit: BoxFit.cover,
                                                        ),
                                                      ),
                            )
                            : GestureDetector(
                          onTap: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context)=> const ProfilePicturePage())
                            );
                          },
                              child: const Icon(
                                Icons.account_circle,
                                size: 100,
                                color: Colors.green,
                              ),
                            );
                      }
                    },
                  ),


      FutureBuilder<DocumentSnapshot>(
        future: _firestore.collection('users').doc(user.uid).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data == null || !snapshot.data!.exists) {
            return const Text('No data found for the user');
          } else {
            var userData = snapshot.data!.data() as Map<String, dynamic>;
            var username = userData['username'] as String?;
            var useremail = userData['email'] as String?;

            return username != null

                ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(username,
                style: const TextStyle(
                  fontSize: 22,
                  fontFamily: "Pacifico",
                ),
                ),
                // You can display more user details here if needed
              ],
            )
                :  Text(user.email!);
          }
        },
      ),

                ],
              ),
            ),
            ListTile(
              leading: GestureDetector(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  NBA()),
                  );
                },
                child: Icon(
                  Icons.home,
                  color: Colors.green,
                  size: 40,
                ),
              ),
              title: Text('D A S H B O A R D'),
            ),
            ListTile(
              leading: GestureDetector(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => News())
                  );
                },
                child: Icon(
                  Icons.chat,
                  color: Colors.green,
                  size: 40,
                ),
              ),
              title: const Text('M E S S A G E'),
            ),

            ListTile(
              leading: GestureDetector(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  ProfilePage(),
                    ),
                  );
                },
                child: const Icon(
                  Icons.person,
                  color: Colors.green,
                  size: 40,
                ),
              ),
              title: const Text('P R O F I L E'),
            ),
            ListTile(
              leading: GestureDetector(
                onTap: (){
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => ChatPage(),
    ),
    );
    },
                child: Icon(
                  Icons.settings,
                  color: Colors.green,
                  size: 40,
                ),
              ),
              title: Text('S E T T I N G S'),
            ),
            ListTile(
              leading: IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () => logout(),
              ),
            ),

          ],
        ),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
            icon: Icon(Icons.home,
              color: Colors.green,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: (){
                Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder:(context)=> const GreenCommunity())
                );
                },
              child: const Icon(Icons.people,
              color: Colors.green,
              ),
            ),
            label: 'Green Community',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on,
              color: Colors.green,
            ),
            label: 'Donate',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.notifications,
            color: Colors.green,
            ),
            label: 'Notifications',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
