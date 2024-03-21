import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:green_environment/pages/change_password.dart';
import 'package:green_environment/pages/my_text_field.dart';
import 'package:green_environment/pages/tile.dart';
import 'package:green_environment/pages/weather.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'my_button.dart';

class LoginPage extends StatefulWidget{
  final Function()? onTap;
  const  LoginPage({super.key,
    required this.onTap,
  });
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void SignUserIn() async {
    //loading circle
    showDialog(context: context, builder: (context) {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.green,
        ),

      );
    },
    );
      final authService = Provider.of<AuthService>(context, listen: false);

    //Sign user in

    try {
      await authService.signInWithEmailandPassword(
         emailController.text,
         passwordController.text,
      );
      Navigator.pop(context);
    }  catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content:Text(
            e.toString(),
            style: const TextStyle(
              color: Colors.red,
            ),
          ),
          ),
      );
    }

  }
  //error message
  void showErrorMessage(String message){
    showDialog(context: context, builder:(context){
      return AlertDialog(
        backgroundColor: Colors.brown,
        title:Column(
          children: [
            const Icon(Icons.warning,
              size: 40,
            ),
            const SizedBox(height:10),
            Text(
              message,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      );
    });
  }




  @override

  Widget build(BuildContext context){

    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("lib/images/go1.jpeg"),
              fit: BoxFit.cover,
            )
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height:50),
                  const Icon(Icons.lock,
                    color: Colors.white,
                    size:100,
                  ),
                  const SizedBox(height:50),

                  const Text('Hello, Welcome Back!',
                    style:TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      //backgroundColor: Colors.green[900],
                    ),
                  ),
                  const SizedBox(height:25),
                  //user name
                  MyTextField(
                    hintText: 'Email',
                    controller: emailController,
                    obscureText: false,
                    focusNode: null,
                  ),
                  const SizedBox(height:20),
                  //password

                  MyTextField(
                    focusNode: null,
                    hintText: 'Password',
                    controller:passwordController,
                    obscureText:true,
                  ),
                  const SizedBox(height:25),
                  //forgot password
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Row(
                      mainAxisAlignment:MainAxisAlignment.end ,
                      children: [
                        GestureDetector(
                          onTap: () => const ForgotPasswordPage(),
                          child: const Text('Forgot Password?',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              backgroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  //button
                  MyButton(
                    text:'Sign In',
                    onTap: SignUserIn,
                  ),
                  const SizedBox(height:25),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: Row(
                      children: [
                        Expanded(child: Divider(
                          thickness: 1.5,
                          color: Colors.white,
                        ),
                        ),
                        SizedBox(width:8,),
                        Text('or login with',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            // backgroundColor: Colors.green[900],
                            fontSize: 22,
                          ),
                        ),
                        SizedBox(width:8),
                        Expanded(child: Divider(
                          thickness: 1.5,
                          color: Colors.white,
                        )),

                      ],
                    ),
                  ),
                  const SizedBox(height:25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MyTile(
                        onTap: ()=> {},
                        filePath: ('lib/images/google.png'),
                      ),
                      SizedBox(width: 10),
                      MyTile(
                        onTap:(){},
                        filePath: ('lib/images/apple.png'),
                      ),


                    ],
                  ),
                  SizedBox(height:25),
                  //not a member? Register now!

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Not a Member?",
                        style: TextStyle(
                          color: Colors.white,
                          // backgroundColor: Colors.green[900],
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width:4),

                      GestureDetector(
                        onTap:widget.onTap,
                        child: const Text("Register Now!",
                          style: TextStyle(
                            color:Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            backgroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}