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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Image.asset(
            imagePath,
            fit: BoxFit.cover,
            width: double.infinity,
          ),
            SizedBox(height:70),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize:32,
                  fontWeight: FontWeight.bold,

                ),
              ),
            ),
            SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal:25),
              child:Text(
                subtitle,
                style: TextStyle(
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
