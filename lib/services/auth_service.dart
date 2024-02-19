

  import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthService extends ChangeNotifier{
  //instance of auth
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
//instance of firestorm
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    // sign user in
   Future<UserCredential> signInWithEmailandPassword(String email, String password) async {
     try{
       //signs in
       UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
         email: email,
         password: password,
       );
       //add a new document for the user in users collection if it doesn't exist
       _firestore.collection('users').doc(userCredential.user!.uid).set({

         'uid' : userCredential.user!.uid,
         'email': email,
       },
       SetOptions(merge: true),
       );
     return userCredential;
     } on FirebaseAuthException catch (e) {
       throw Exception(e.code);
     }
    }

    //create user

    Future<UserCredential> signUpWithEmailandPassword(String email, password) async {
     try{
       UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
           email: email,
           password: password,
       );
       //after creating the user, create a new document for the users collection
       _firestore.collection('users').doc(userCredential.user!.uid).set({
         'uid' : userCredential.user!.uid,
         'email': email,
         'username': userCredential.user!.email?.split('@')[0],
         'profession': "",
         'profileImage':"https://firebasestorage.googleapis.com/v0/b/greenenvironment-5929a.appspot.com/o/profile_images%2F1707666402101?alt=media&token=b367e741-a86a-4798-ae48-9362b49a2603",
       });

       return userCredential;
     } on FirebaseAuthException catch (e){
       throw Exception(e.code);
     }
    }
    // sign user out
   Future<void> signOut() async {
     return await FirebaseAuth.instance.signOut();
   }
}