import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePicturePage extends StatefulWidget {
  const ProfilePicturePage({super.key});

  @override
  _ProfilePicturePageState createState() => _ProfilePicturePageState();
}

class _ProfilePicturePageState extends State<ProfilePicturePage> {
  File? _image;
  final user = FirebaseAuth.instance.currentUser!;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to open the image picker
  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    } catch (e) {
      _handleError('Error picking image: $e');
    }
  }

  // Function to upload the image to Firestore
  Future<void> _uploadImageToFirestore() async {
    if (_image == null) return;

    try {
      Uint8List imageBytes = Uint8List.fromList(await _image!.readAsBytes());
      Reference storageReference = _storage.ref().child('profile_images/${DateTime.now().millisecondsSinceEpoch}');
      await storageReference.putData(imageBytes);

      String imageUrl = await storageReference.getDownloadURL();
      String userId = user.uid;

      await _firestore.collection('users').doc(userId).set({
        'profileImage': imageUrl,
      }, SetOptions(merge: true)
      ).then((value) => {
        Fluttertoast.showToast(
            msg: "Image uploaded successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 4,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 20.0
        )
      });


    } catch (error) {
      _handleError('Error uploading image: $error');
    }
  }

  // Function to handle lost data
  Future<void> _handleLostData() async {
    try {
      final ImagePicker picker = ImagePicker();
      final LostDataResponse response = await picker.retrieveLostData();

      if (response.isEmpty) {
        return;
      }

      final List<XFile>? files = response.files;

      if (files != null) {
        _handleLostFiles(files);
      } else {
        _handleError(response.exception);
      }
    } catch (e) {
      _handleError('Error handling lost data: $e');
    }
  }

  void _handleLostFiles(List<XFile> files) {
    // Process the recovered files
    for (XFile file in files) {
      print('Recovered file path: ${file.path}');
      // Handle each recovered file as needed
    }
  }

  void _handleError(dynamic errorMessage) {
    // Handle the error message
    print('Error: $errorMessage');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Profile Picture',
        style: TextStyle(
          color: Colors.white,
          fontFamily: "Lobster",
        ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 10),
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
                return profileImageUrl != null
                    ? ClipOval(
                  child: Image.network(
                    profileImageUrl,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                )
                    : const Placeholder(
                  fallbackHeight: 100,
                  fallbackWidth: 100,
                );
              }
            },
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  IconButton(onPressed: () async {
                    await _pickImage(ImageSource.camera);
                    await _handleLostData();
                  },
                      icon:const Icon(Icons.camera_alt_outlined,
                        size: 60,
                        color: Colors.green,
                      )),
                  //take a photo
                  const Text("Take Photo")
                ],
              ),
              const SizedBox(width: 20),
              Column(
                children: [
                  IconButton(onPressed: () async {
                    await _pickImage(ImageSource.gallery);
                    await _handleLostData();
                  }, icon: Icon(Icons.image,
                    size: 60,
                    color: Colors.green,
                  )

                  ),
                  //gallery

                  Text("Choose Photo")
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _uploadImageToFirestore,
            child: const Text('Upload Image',
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 18,

            ),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: ProfilePicturePage(),
  ));
}
