import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:green_environment/services/auth_service.dart';
import 'package:green_environment/services/chat_service.dart'; // Import ChatService
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'pages/auth_page.dart';

void main() async {
  //initialize firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => ChatService()), // Add ChatService provider
        //other providers if needed
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const AuthPage(),
    );
  }


}

/*//initialize mpesa plugin
  MpesaFlutterPlugin.setConsumerKey('xuQEiJoIYczCr4IRPsC1WdGNtwFBgIAIK5AEZms3hyWicoog');
  MpesaFlutterPlugin.setConsumerSecret('FGuaA8eZ7HiK7TihW3UYkV3HvwL9gw7HEhCWU7PXbgKVaWAdPQzx2Kfl8C6cx5BF');*/