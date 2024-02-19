import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Players extends StatefulWidget {
  Players({Key? key}) : super(key: key);

  @override
  _PlayersState createState() => _PlayersState();
}

class _PlayersState extends State<Players> {
  List<Player> players = [];

  Future<List<Player>> getPlayers() async {
    try {
      var response = await http.get(Uri.https('dummyjson.com', 'products'));

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        if (jsonData['products'] != null && jsonData['products'] is List) {
          List<Player> players = (jsonData['products'] as List)
              .map((productData) => Player.fromJson(productData))
              .toList();

          return players;
        } else {
          // Print response body for debugging
          print('Invalid data format - Missing or invalid "products" key: ${response.body}');
          throw Exception('Invalid data format');
        }
      } else {
        // Print response status code and body for debugging
        print('HTTP error - Status code: ${response.statusCode}, Body: ${response.body}');
        throw Exception('Failed to load players');
      }
    } catch (e) {
      // Print other errors for debugging
      print('Error: $e');
      throw Exception('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Players"),
        backgroundColor: Colors.pink,
      ),
      body: FutureBuilder(
        future: getPlayers(),
        builder: (context, AsyncSnapshot<List<Player>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }

            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.all(12),
                  margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.pink,
                    )
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(snapshot.data![index].title),

                            Image.network(snapshot.data![index].thumbnail,
                              height: 100,
                            ),
                            Column(
                              children: [
                                Text("Description:",

                              style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                                ),
                                SizedBox(height: 10),
                                Text(snapshot.data![index].description),
                              ],
                            ),
                            Row(
                              children: [
                                Text("Price: \$",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                                ),
                                SizedBox(width:4),
                                Text(snapshot.data![index].price.toString()),
                              ],
                            ),

                          ],
                      ),


                    ],
                  ),
                );
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            );
          }
        },
      ),
    );
  }
}

class Player {
  final String title;
  final String description;
  final int price;
  final String thumbnail;

  Player({
    required this.title,
    required this.description,
    required this.price,
    required this.thumbnail
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      title: json['title'] ?? 'No Title',
      description: json['description'] ?? 'No Description',
      price: json['price'] ?? 'No Price',
      thumbnail: json['thumbnail'] ?? 'No thumbnail'
    );

  }
}

void main() {
  runApp(MaterialApp(
    home: Players(),
  ));
}
