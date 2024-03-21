import 'package:flutter/material.dart';

import '../onboard.dart';

class IntroPage2 extends StatelessWidget {
  const IntroPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return  const Onboard(
      color: Colors.green,
      imagePath: ("lib/images/plant.jpg"),
      title: 'Embrace the Power of Green,'
          ' with Tree Planting',
      subtitle: "Join us in our mission to make a tangible impact on the environment "
          "by actively participating in tree planting initiatives. Trees are the "
          "lungs of our planet, absorbing carbon dioxide and providing us with oxygen."
          " By planting trees, you contribute to cleaner air, a healthier ecosystem, "
          "and a greener future for generations to come. Twende Green Hub offers exciting "
          "opportunities to get your hands dirty and plant trees in various locations. "
          "Let's grow a forest of positive change together and witness the transformative power of nature!",
    );
  }
}