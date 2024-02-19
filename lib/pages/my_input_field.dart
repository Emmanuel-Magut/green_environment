import 'package:flutter/material.dart';

class MyInputField extends StatelessWidget {
  final hintText;
  final controller;
  final obscureText;
  final FocusNode? focusNode;

  const MyInputField({
    Key? key,
    required this.hintText,
    required this.controller,
    required this.obscureText,
    required this.focusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Container(
        width: MediaQuery.of(context).size.width, // Occupy available device width
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          border: Border.all(
            color: Colors.green,
          ),
        ),
        child: TextField(
          maxLines: null,
          obscureText: obscureText,
          controller: controller,
          decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.green,
              ),
            ),
            fillColor: Colors.grey.shade100,
            filled: true,
            hintText: hintText,
          ),
        ),
      ),
    );
  }
}
