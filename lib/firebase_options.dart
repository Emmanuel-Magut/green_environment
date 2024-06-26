// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBRc2Q7_HzZx6MyuqY8O7x1GO1H4YRE3nE',
    appId: '1:672373891733:web:782a13e1843685d861f19c',
    messagingSenderId: '672373891733',
    projectId: 'greenenvironment-5929a',
    authDomain: 'greenenvironment-5929a.firebaseapp.com',
    storageBucket: 'greenenvironment-5929a.appspot.com',
    measurementId: 'G-XQZJ8GQ5YX',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDLoBKi1-zgwA2CjMBsDzl34lJU61UoUoc',
    appId: '1:672373891733:android:3c33b32d2f42a9a861f19c',
    messagingSenderId: '672373891733',
    projectId: 'greenenvironment-5929a',
    storageBucket: 'greenenvironment-5929a.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDvIQQu48DXYUGTDgm6Kg7CTRw2fFqkIao',
    appId: '1:672373891733:ios:553c640c876edb8b61f19c',
    messagingSenderId: '672373891733',
    projectId: 'greenenvironment-5929a',
    storageBucket: 'greenenvironment-5929a.appspot.com',
    iosBundleId: 'com.example.greenEnvironment',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDvIQQu48DXYUGTDgm6Kg7CTRw2fFqkIao',
    appId: '1:672373891733:ios:4041fc835ce3b66761f19c',
    messagingSenderId: '672373891733',
    projectId: 'greenenvironment-5929a',
    storageBucket: 'greenenvironment-5929a.appspot.com',
    iosBundleId: 'com.example.greenEnvironment.RunnerTests',
  );
}
