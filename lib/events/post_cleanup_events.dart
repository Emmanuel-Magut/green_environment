import 'dart:ffi';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class PostCleanUp extends StatefulWidget {
  const PostCleanUp({Key? key}) : super(key: key);

  @override
  State<PostCleanUp> createState() => _PostCleanUpState();
}

class _PostCleanUpState extends State<PostCleanUp> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();
  String _title = "";
  String _description = "";
  late int _phone;
  String _location = "";
  String _geolocation = "";
  String _county = "";
  DateTime _selectedDate = DateTime.now();
  String _imageUrl = ""; // Optional for image URL
  File? _image;
  TextEditingController _geoLocationController = TextEditingController();

  final List<String> counties = [
    'Baringo', 'Bomet', 'Bungoma', 'Busia', 'Elgeyo Marakwet', 'Embu', 'Garissa',
    'Homa Bay', 'Isiolo', 'Kajiado', 'Kakamega', 'Kericho', 'Kiambu', 'Kilifi', 'Kirinyaga',
    'Kisii', 'Kisumu', 'Kitui', 'Kwale', 'Laikipia', 'Lamu', 'Machakos', 'Makueni', 'Mandera',
    'Marsabit', 'Meru', 'Migori', 'Mombasa', 'Murang\'a', 'Nairobi', 'Nakuru', 'Nandi', 'Narok',
    'Nyamira', 'Nyandarua', 'Nyeri', 'Samburu', 'Siaya', 'Taita Taveta', 'Tana River', 'Tharaka Nithi',
    'Trans Nzoia', 'Turkana', 'Uasin Gishu', 'Vihiga', 'Wajir', 'West Pokot'
  ];


  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _fetchUserCurrentLocation() async {
    try {
      var status = await Permission.location.request();

      if (status == PermissionStatus.granted) {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        double latitude = position.latitude;
        double longitude = position.longitude;

        setState(() {
          _geolocation = 'Latitude: $latitude, Longitude: $longitude';
        });

        _geoLocationController.text = _geolocation; // Update the controller

        // Debug by printing the retrieved latitude and longitude:
        print('Latitude: $latitude, Longitude: $longitude');
      } else {
        // Handle if location permission is not granted
      }
    } catch (e) {
      print('Error fetching location: $e');
      // Handle the error gracefully, e.g., show a message to the user
    }
  }

  Future<void> _getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _submitEvent() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        Uint8List? imageBytes;
        String? imageUrl;

        if (_image != null) {
          imageBytes = Uint8List.fromList(await _image!.readAsBytes());
          Reference storageReference = _storage.ref().child('images/${DateTime.now().millisecondsSinceEpoch}');
          await storageReference.putData(imageBytes);
          imageUrl = await storageReference.getDownloadURL();
        } else {
          // Set imageUrl to an empty string if no image is selected
          imageUrl = '';
        }

        // Initialize attendees list as empty
        List<String> attendees = [];

        // Add event data to Firestore
        DocumentReference docRef = await FirebaseFirestore.instance.collection('garbage_collection').add({
          'email': currentUser.email,
          'uid': currentUser.uid,
          'title': _title,
          'description': _description,
          'phone': _phone,
          'location': _location,
          'county': _county, // Save the selected county
          'geolocation': _geolocation,
          'date': _selectedDate,
          'imageUrl': imageUrl, // Add imageUrl conditionally
          'attendees': attendees, // Add attendees field
          'event_status': 'Pending', // Add event status with default value
          // Add additional fields as needed
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Event posted successfully!'),
            duration: Duration(seconds: 2),
          ),
        );

        // Optionally navigate back to previous screen
        Navigator.pop(context);
      } catch (error) {
        // Handle errors
        print('Error posting event: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An error occurred. Please try again later.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Clean Up Event'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Event Title',
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title for your event.';
                  }
                  return null;
                },
                onSaved: (value) => setState(() => _title = value!),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Description',
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please provide a description of your event.';
                  }
                  return null;
                },
                onSaved: (value) => setState(() => _description = value!),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Phone',
                  prefixIcon: Icon(Icons.phone),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter phone number.';
                  }
                  return null;
                },
                onSaved: (value) => setState(() => _phone = int.parse(value!)),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Location',
                  prefixIcon: Icon(Icons.location_on_outlined),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter event Location.';
                  }
                  return null;
                },
                onSaved: (value) => setState(() => _location = value!),
              ),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: _county.isNotEmpty ? _county : null, // Add a null check here
                onChanged: (String? newValue) {
                  setState(() {
                    _county = newValue!;
                  });
                },
                items: counties.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(
                  hintText: 'Select County',
                  prefixIcon: Icon(Icons.location_city),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a county.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _geoLocationController, // Use the controller
                readOnly: true,
                decoration: InputDecoration(
                  hintText: 'GeoLocation',
                  suffixIcon: GestureDetector(
                    onTap: _fetchUserCurrentLocation,
                    child: Icon(Icons.location_searching),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Add Geo Location.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: TextEditingController(text: DateFormat('y MMMM d').format(_selectedDate)),
                readOnly: true,
                decoration: InputDecoration(
                  hintText: 'Date',
                  suffixIcon: GestureDetector(
                    onTap: _selectDate,
                    child: const Icon(Icons.calendar_today),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter event Date.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              if (_image != null)
                Container(
                  height: 220,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(_image!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _getImage,
                child: const Text('Add Image'),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitEvent,
                child: const Text('Post Event'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
