import 'package:flutter/material.dart';

class Locations extends StatelessWidget {
  final imagePath;
  final text;
  const Locations({super.key,
   required this.imagePath,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Image.asset(imagePath,
          height: 140,
          ),
          SizedBox(height:10),
          Text(text,
            style: TextStyle(
              fontSize: 18,

            ),
          ),
        ],
      ),
    );
  }
}
