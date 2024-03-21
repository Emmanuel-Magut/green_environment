import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class TreesPlantedByCountyChart extends StatefulWidget {
  const TreesPlantedByCountyChart({Key? key}) : super(key: key);

  @override
  _TreesPlantedByCountyChartState createState() =>
      _TreesPlantedByCountyChartState();
}

class _TreesPlantedByCountyChartState
    extends State<TreesPlantedByCountyChart> {
  List<charts.Series<MapEntry<String, int>, String>>? _seriesList;

  @override
  void initState() {
    super.initState();
    _generateData();
  }

  Future<void> _generateData() async {
    List<MapEntry<String, int>> data = [];

    // Query the upcoming_events collection
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('upcoming_events')
        .get();

    // Extract county and trees planted data from each document
    querySnapshot.docs.forEach((doc) {
      final county = doc['county'];
      final treesPlanted =
          doc['total_trees_planted'] ?? 0; // If total_trees_planted is null, default to 0
      data.add(MapEntry(county, treesPlanted));
    });

    // Aggregate the number of trees planted for each county
    Map<String, int> aggregatedData = {};
    data.forEach((entry) {
      if (aggregatedData.containsKey(entry.key)) {
        aggregatedData[entry.key] = aggregatedData[entry.key]! + entry.value;
      } else {
        aggregatedData[entry.key] = entry.value;
      }
    });

    // Sort aggregated data in descending order based on the number of trees planted
    var sortedEntries = aggregatedData.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Take only the top 10 entries
    sortedEntries = sortedEntries.take(10).toList();

    // Convert sorted data to a list of series for charting
    List<charts.Series<MapEntry<String, int>, String>> seriesList = [
      charts.Series<MapEntry<String, int>, String>(
        id: 'TreesPlantedByCounty',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (entry, _) => entry.key,
        measureFn: (entry, _) => entry.value,
        data: sortedEntries,
      )
    ];

    setState(() {
      _seriesList = seriesList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Top 10 Counties by Trees Planted',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: _seriesList != null
            ? charts.BarChart(
          _seriesList!,
          animate: true,
          vertical: true, // Display bars vertically
          barRendererDecorator: charts.BarLabelDecorator<String>(),
          domainAxis: const charts.OrdinalAxisSpec(
            renderSpec: charts.NoneRenderSpec(),
          ),
        )
            : const CircularProgressIndicator(
          color: Colors.green,
        ),
      ),
    );
  }
}
