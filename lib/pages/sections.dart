import 'package:flutter/material.dart';

class SectionsContainer extends StatelessWidget {
  final Function()? onTap;
  final imagePath;
  final text;
  const SectionsContainer({super.key,
  required this.imagePath,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration:  BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        elevation: 10,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Column(
            children: [
              GestureDetector(
                onTap: onTap,
                child: Image.asset(imagePath,
                  height: 100,
                ),
              ),
              const SizedBox(height: 10),
              Text(text,
              style: TextStyle(
                fontWeight: FontWeight.bold,

              ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
