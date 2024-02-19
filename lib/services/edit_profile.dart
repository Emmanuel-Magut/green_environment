import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EditUserDetailsPage extends StatefulWidget {


  @override
  _EditUserDetailsPageState createState() => _EditUserDetailsPageState();
}

class _EditUserDetailsPageState extends State<EditUserDetailsPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _residenceController = TextEditingController();
  final TextEditingController _professionController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser!;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Fetch user details and initialize controllers
    fetchUserDetails();
  }

  Future<void> fetchUserDetails() async {
    try {
      // Fetch user details based on the user ID
      Map<String, dynamic> userDetails = await getUserDetails(user.uid);

      // Initialize controllers with current data
      _usernameController.text = userDetails['username'] ?? '';
      _genderController.text = userDetails['gender'] ?? '';
      _residenceController.text = userDetails['residence'] ?? '';
      _professionController.text = userDetails['profession'] ?? '';
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing user details: $e');
      }
    }
  }

  Future<Map<String, dynamic>> getUserDetails(String uid) async {
    DocumentSnapshot userSnapshot =
    await _firestore.collection('users').doc(uid).get(

    );

    return userSnapshot.data() as Map<String, dynamic>;
  }

  Future<void> editUserDetails() async {
    try {
      // Update user details in Firestore
      await _firestore.collection('users').doc(user.uid).update(
        {
          'username': _usernameController.text,
          'gender': _genderController.text,
          'residence': _residenceController.text,
          'profession': _professionController.text,
        },

      ).then((value) => {
        Fluttertoast.showToast(
            msg: "Your Profile Was Edited successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 6,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 20.0
        )
      });

    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update your details.Please try again.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Edit Your Profile',
          style: TextStyle(
            color: Colors.white,
          ),
          ),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Username required';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _genderController,
                decoration: const InputDecoration(labelText: 'Gender'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Gender required';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _residenceController,
                decoration: const InputDecoration(labelText: 'Residence'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Residence required';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _professionController,
                decoration: const InputDecoration(labelText: 'Profession'),

              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: (){
                  if (_formKey.currentState!.validate()){
                    editUserDetails();
                  }
                },
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


