import 'package:flutter/material.dart';

class Onboard extends StatelessWidget {
  final color;
  final imagePath;
  final title;
  final subtitle;

  const Onboard({super.key,
  required this.color,
    required this.imagePath,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: color,
        child: Column(

          children: [
          Image.asset(
            imagePath,

            fit: BoxFit.cover,
            width: double.infinity,
          ),
            const SizedBox(height:40),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize:32,
                  fontWeight: FontWeight.bold,

                ),
              ),
            ),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.symmetric(horizontal:25),
              child:Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
