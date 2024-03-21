import 'package:flutter/material.dart';
import 'package:green_environment/pages/onboard.dart';

class IntroPage1 extends StatelessWidget {
  const IntroPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return const Onboard(
      color: Colors.green,
      imagePath: ("lib/images/enviroment.png"),
      title: 'Twende Green Hub',
      subtitle: "Welcome to Twende Green Hub! "
          "We are thrilled to have you on board as part of our green community. "
          "At Twende Green Hub, we believe in the power of collective action to "
          "create a sustainable and eco-friendly future. On this platform, "
          "you'll discover exciting opportunities to contribute to a greener "
          "environment, connect with like-minded individuals, and access "
          "valuable resources to promote sustainable living. Together, let's "
          "embark on a journey towards a more environmentally conscious and vibrant world. "
          "Thank you for joining Twende Green Hub – where every small action makes a big impact!",
    );
  }
}