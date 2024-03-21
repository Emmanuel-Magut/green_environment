import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:green_environment/pages/home_page.dart';
import 'package:green_environment/pages/login_or_register_page.dart';
import 'package:green_environment/pages/onboarding_screen.dart';



class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder:(context, snapshot){
          //user is logged in
          if (snapshot.hasData){
            return const OnboardingScreen();
          }
          // user is NOT logged in
          else {
            return const LoginOrRegisterPage();
          }
        },
      ),
    );
  }
}
