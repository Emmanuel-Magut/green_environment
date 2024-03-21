import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TreesPlanted extends StatefulWidget {
  const TreesPlanted({Key? key}) : super(key: key);

  @override
  _TreesPlantedState createState() => _TreesPlantedState();
}

class _TreesPlantedState extends State<TreesPlanted> {
  String totalTreesPlantedFormatted = '';

  @override
  void initState() {
    super.initState();
    getTotalTreesPlantedFormatted();
  }

  Future<void> getTotalTreesPlantedFormatted() async {
    int totalTreesPlanted = await getTotalTreesPlanted();
    setState(() {
      totalTreesPlantedFormatted = formatNumber(totalTreesPlanted);
    });
  }

  Future<int> getTotalTreesPlanted() async {
    int totalTreesPlanted = 0;

    // Query the upcoming_events collection
    QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection('upcoming_events').get();

    // Loop through each document in the collection
    querySnapshot.docs.forEach((doc) {
      // Cast doc.data() to Map<String, dynamic> to ensure type safety
      final Map<String, dynamic>? eventData = doc.data() as Map<String, dynamic>?;

      // Check if the eventData is not null and contains the 'total_trees_planted' field
      if (eventData != null && eventData.containsKey('total_trees_planted')) {
        // Add the total_trees_planted value to the totalTreesPlanted variable after casting to int
        totalTreesPlanted += (eventData['total_trees_planted'] as int);
      }
    });

    return totalTreesPlanted;
  }

  String formatNumber(int number) {
    if (number >= 1000000000) {
      return '${(number / 1000000000).toStringAsFixed(1)}B'; // Convert to billions
    } else if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M'; // Convert to millions
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}k'; // Convert to thousands
    } else {
      return number.toString(); // No conversion needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(

      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.green,
        )
      ),
      child: Center(
        child: Column(
          children: [
           Image.asset('lib/images/tree.png',
           height: 50,
           ),
            Text(
              ' $totalTreesPlantedFormatted' ,
              style: const TextStyle(fontSize: 20),
            ),
            const Text('Trees Planted',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            )
          ],
        ),
      ),
    );
  }
}
