import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:green_environment/pages/my_text_field.dart';
import 'package:green_environment/pages/tile.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'my_button.dart';


class RegisterPage extends StatefulWidget{
  final Function()? onTap;
  const  RegisterPage({super.key,
    required this.onTap,
  });
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();





  //sign up user

  void signUp() async {
    if(passwordController.text != confirmPasswordController.text){
     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
         content:Text("Passwords do not match"),
     ),
     );
     return;
    }
    //get auth service
    final authService = Provider.of<AuthService>(context, listen:false);

    try {
      await authService.signUpWithEmailandPassword(
          emailController.text,
          passwordController.text,
      ).then((value) => {
        Fluttertoast.showToast(
            msg: "Account Created successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 4,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 20.0
        )
      });


    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString(),
        ),
      ),
      );
    }

  }



    @override

  Widget build(BuildContext context){

    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("lib/images/go1.jpeg"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height:50),
                  Icon(Icons.lock,
                    size:100,
                    color: Colors.white,
                  ),
                  SizedBox(height:50),

                  const Text('Register Account.',
                    style:TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color:Colors.white,
                      //backgroundColor: Colors.green[900],
                    ),
                  ),
                  SizedBox(height:25),
                  //user name
                  MyTextField(
                    hintText: 'Email',
                    controller: emailController,
                    obscureText: false,
                    focusNode: null,
                  ),
                  SizedBox(height:20),
                  //password

                  MyTextField(
                    focusNode: null,
                    hintText: 'Password',
                    controller:passwordController,
                    obscureText:true,
                  ),
                  SizedBox(height:25),

                  MyTextField(
                    focusNode: null,
                    hintText: 'Confirm Password',
                    controller:confirmPasswordController,
                    obscureText:true,
                  ),
                  SizedBox(height:25),
                  //forgot password

                  //button
                  MyButton(
                    text:'Register',
                    onTap: () => signUp(),
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
                        SizedBox(width:8),
                        Text('or continue with',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                         // backgroundColor: Colors.green[900],
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
                  SizedBox(height:25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MyTile(
                        onTap:()=> {},
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
                      Text("Already Have an account?",
                      style: TextStyle(
                        color: Colors.white,
                        //backgroundColor: Colors.green[900],
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      ),
                      SizedBox(width:4),

                      GestureDetector(
                        onTap:widget.onTap,
                        child: Text("Login Now!",
                          style: TextStyle(
                            color:Colors.blue,
                            backgroundColor: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

