import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:green_environment/services/edit_profile.dart';
import 'package:green_environment/services/profile_picture.dart';

class ProfilePage extends StatefulWidget {
  final usernameController = TextEditingController();
  final genderController = TextEditingController();
  final residenceController = TextEditingController();
  final professionController = TextEditingController();

  ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = FirebaseAuth.instance.currentUser!;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();

  void completeProfile() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: widget.usernameController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.person,
                      color: Colors.green,
                      size: 40,
                    ),
                    hintText: 'Enter your username',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Username required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: widget.genderController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.female_sharp,
                      color: Colors.green,
                      size: 40,
                    ),
                    hintText: 'Gender',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Gender required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: widget.residenceController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.my_location,
                      color: Colors.green,
                      size: 40,
                    ),
                    hintText: 'Residence',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Residence required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: widget.professionController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.school,
                      color: Colors.green,
                      size: 40,
                    ),
                    hintText: 'Profession',
                  ),

                ),
                SizedBox(height: 40),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        // Call the function to add user details to Firestore
                        addUserDetails(
                          user.uid,
                          widget.usernameController.text,
                          widget.genderController.text,
                          widget.residenceController.text,
                          widget.professionController.text,
                        );
                        Navigator.pop(context); // Close the dialog
                      }
                    },
                    child: Text(
                      "Submit",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> addUserDetails(
      String uid,
      String username,
      String gender,
      String residence,
      String profession,
      ) async {
    await _firestore.collection('users').doc(uid).set(
      {
        'username': username,
        'gender': gender,
        'residence': residence,
        'profession': profession,
      },
      SetOptions(merge: true),
    ).then((value) => {
    Fluttertoast.showToast(
    msg: "Profile Has been recorded successfully",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
    timeInSecForIosWeb: 2,
    backgroundColor: Colors.green,
    textColor: Colors.white,
    fontSize: 18.0
    )
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          "Profile",
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Lobster",
            fontSize: 27,
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 30),
          //complete profile and Edit profile buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.green,
                ),
                child: TextButton(
                  onPressed: completeProfile,
                  child: const Text(
                    "Complete Profile",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 25),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.green,
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context)=> EditUserDetailsPage())
                    );
                  },
                  child: const Text(
                    "Edit Profile",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 50),
          //profile picture

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
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfilePicturePage(),
                      ),
                    );
                  },
                  child: ClipOval(
                    child: Image.network(
                      profileImageUrl,
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
                    : GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfilePicturePage(),
                      ),
                    );
                  },
                  child: Icon(
                    Icons.account_circle,
                    size: 100,
                    color: Colors.green,
                  ),
                );
              }
            },
          ),

          //profile details
      FutureBuilder<DocumentSnapshot>(
        future: _firestore.collection('users').doc(user.uid).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data == null || !snapshot.data!.exists) {
            return const Text('No data found for the user');
          } else {
            var userData = snapshot.data!.data() as Map<String, dynamic>;

            // Retrieve fields from the document
            var username = userData['username'] as String?;
            var gender = userData['gender'] as String?;
            var profession = userData['profession'] as String?;
            var residence = userData['residence'] as String?;

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              margin: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.green,
                      )
                    ),
                    child: Column(
                      children: [

                        if (username != null) Text('User Name: $username',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,

                        ),
                        ),

                        const Divider(
                          thickness: 1,
                            color: Colors.green,
                        ),
                        if (gender != null) Text('Gender: $gender',
          style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,

          ),
                        ),
                        const Divider(
                          thickness: 1,
                          color: Colors.green,
                        ),
                        if (profession != null) Text('Profession: $profession',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,

                          ),
                        ),
                        const Divider(
                          thickness: 1,
                          color: Colors.green,
                        ),
                        if (residence != null) Text('Residence: $residence',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,

                          ),
                        ),
                      ],
                    ),
                  ),


                ],
              ),
            );
          }
        },
      ),


        ],
      ),
    );
  }
}
