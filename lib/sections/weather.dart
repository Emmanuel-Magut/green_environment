import 'package:flutter/material.dart';

class Weather extends StatefulWidget {
  const Weather({super.key});

  @override
  State<Weather> createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        backgroundColor: Colors.green,
        title: const Text("Today's Weather",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: "Georgia",
            color: Colors.white,
          ),
        ),
      ),
      body: Center(
        child: Text("Welcome"),
      ),
    );
  }
}
