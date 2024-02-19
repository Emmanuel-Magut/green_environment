import 'package:flutter/material.dart';

import 'locations.dart';

class GeolocationServices extends StatefulWidget {
  const GeolocationServices({super.key});

  @override
  State<GeolocationServices> createState() => _GeolocationServicesState();
}

class _GeolocationServicesState extends State<GeolocationServices> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
       title: const Text("Location Finder",
       style: TextStyle(
         fontWeight: FontWeight.bold,
         fontFamily: "Georgia",
         color: Colors.white,
       ),
       ),
      ),
      body:GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10
        ),

        children: [
        const Locations(
          imagePath:("lib/images/gardens.png"),
          text: "Gardens Near Me",
        ),

          const Locations(
            imagePath:("lib/images/plantings.png"),
            text: "Tree planting Nearby",
          ),

          const Locations(
            imagePath:("lib/images/wastes.png"),
            text: "Garbage collections",
          ),

          const Locations(
            imagePath:("lib/images/nursery.png"),
            text: "Tree Nurseries Nearby",
          ),

          const Locations(
            imagePath:("lib/images/summits.png"),
            text: "Climate Summits Nearby",
          ),
        ],
      ),
    );
  }
}
