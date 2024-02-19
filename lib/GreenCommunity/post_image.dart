import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostImage extends StatefulWidget {
  const PostImage({Key? key}) : super(key: key);

  @override
  _PostImageState createState() => _PostImageState();
}

class _PostImageState extends State<PostImage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final textController = TextEditingController();
  File? _image;

  final user = FirebaseAuth.instance.currentUser!;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController _descriptionController = TextEditingController();

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

  Future<void> _uploadImageToFirestore() async {
    if (_image == null) return;

    try {
      Uint8List imageBytes = Uint8List.fromList(await _image!.readAsBytes());
      Reference storageReference =
      _storage.ref().child('images/${DateTime.now().millisecondsSinceEpoch}');
      await storageReference.putData(imageBytes);

      String imageUrl = await storageReference.getDownloadURL();
      if (textController.text.isNotEmpty) {
        FirebaseFirestore.instance.collection('Posts').add({
          "UserEmail": currentUser.email,
          "message": textController.text,
          "imagePost": imageUrl,
          "TimeStamp": Timestamp.now(),
          "Likes": [],
        });
      }
      setState(() {
        textController.clear();
      });
      Navigator.pop(context);


      /*  await _firestore.collection('users').doc(userId).set(
        {
          'profileImage': imageUrl,

        },
        SetOptions(merge: true),
      ).then((value) => {
        Fluttertoast.showToast(
          msg: "success",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 4,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 20.0,
        )
      });  */
    } catch (error) {
      _handleError('Error uploading image: $error');
    }
  }

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
    for (XFile file in files) {
      print('Recovered file path: ${file.path}');
    }
  }

  void _handleError(dynamic errorMessage) {
    print('Errors: $errorMessage');
  }


  /*void postMessage() {
    if (textController.text.isNotEmpty) {
      FirebaseFirestore.instance.collection('Posts').add({
        "UserEmail": currentUser.email,
        "message": textController.text,
        "TimeStamp": Timestamp.now(),
        "Likes": [],

      });


    }

    setState(() {
      textController.clear();
    });
    Navigator.pop(context);
  }
*/











  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          'Add Post',
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Georgia",
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 80),
            Padding(
              padding: const EdgeInsets.only(left: 45),
              child: Row(
                children: [
                  Container(
                    width: 200, // Adjust the width as needed
                    height: 260, // Adjust the height as needed
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green),
                    ),
                    child: _image != null
                        ? Image.file(
                      _image!,
                      fit: BoxFit.cover,
                    )
                        : const Center(
                      child: Text('No Image Selected'),
                    ),
                  ),
                  const SizedBox(width:20),
                  Column(
                    children: [
                      Column(
                        children: [
                          IconButton(
                            onPressed: () async {
                              await _pickImage(ImageSource.camera);
                              await _handleLostData();
                            },
                            icon: const Icon(
                              Icons.camera_alt_outlined,
                              size: 60,
                              color: Colors.green,
                            ),
                          ),
                          const Text("Camera"),
                        ],
                      ),
                      const SizedBox(width: 20),
                      Column(
                        children: [
                          IconButton(
                            onPressed: () async {
                              await _pickImage(ImageSource.gallery);
                              await _handleLostData();
                            },
                            icon: const Icon(
                              Icons.image,
                              size: 60,
                              color: Colors.green,
                            ),
                          ),
                          const Text("Gallery"),
                        ],
                      ),
                    ],
                  ),

                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.green,
                  ),
                ),
                child: TextField(
                  cursorColor: Colors.green,
                  controller: textController,
                  decoration:  InputDecoration(
                    hintText: 'Say something about this photo',
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  maxLines: 4,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.green,
                  ),
                ),
                child: TextButton(
                  onPressed: _uploadImageToFirestore,
                  child: const Text(
                    'Post',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}