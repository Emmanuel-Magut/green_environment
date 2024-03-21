import 'package:flutter/material.dart';

import '../onboard.dart';

class IntroPage3 extends StatelessWidget {
  const IntroPage3({super.key});

  @override
  Widget build(BuildContext context) {
    return   const Onboard(
      color: Colors.green,
      imagePath: ("lib/images/waste.jpg"),
      title: 'Revolutionize Waste Management through Garbage Collection ♻️',
      subtitle: "In our commitment to building a sustainable future, "
          "Twende Green Hub recognizes the crucial role of responsible waste management."
          " Join us in the movement to clean up our surroundings and reduce our ecological footprint. "
          "Engage in organized garbage collection events where every piece of litter collected"
          " contributes to a cleaner, healthier environment. Through proper waste disposal and recycling initiatives, "
          "we can protect our ecosystems, preserve natural resources, and create a cleaner, more vibrant world. "
          "Together, let's turn waste into a valuable resource and lead the way towards a greener and more sustainable planet.",
    );
  }
}
