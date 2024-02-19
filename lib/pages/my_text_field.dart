import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget{

  final hintText;
  final controller;
  final obscureText;
  final FocusNode? focusNode;
  final maxLines;
  const MyTextField({
    required this.hintText,
    required this.controller,
    required this.obscureText,
    required this.focusNode,
    this.maxLines,
  });
  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:25),
      child: TextField(
        obscureText: obscureText,
        controller: controller,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color:Colors.white,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.green,
            ),
          ),
          fillColor: Colors.grey.shade100,
          filled: true,
          hintText: hintText,

        ),
      ),
    );
  }
}