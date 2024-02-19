import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class News extends StatefulWidget {
  News({Key? key}) : super(key: key);

  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> {
  List<Player> players = [];

  Future<List<Player>> getPlayers() async {
    try {
      const String newsApiUrl = 'https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=8f61005dc5fb44fdb354dd2ab8803d83';

      var response = await http.get(Uri.parse(newsApiUrl));


      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        if (jsonData['articles'] != null && jsonData['articles'] is List) {
          List<Player> players = (jsonData['articles'] as List)
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
                          Text(snapshot.data![index].title,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Literata',

                          ),
                          ),
                          SizedBox(height:10),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(snapshot.data![index].urlToImage,
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.fill,
                            ),
                          ),
                          Column(
                            children: [

                              SizedBox(height: 10),
                              Text(snapshot.data![index].content),
                              TextButton(
                                onPressed: () async {
                                  final String url = snapshot.data![index].url;
                                  if (await canLaunchUrl(Uri.parse(url))) {
                                    await launchUrl(Uri.parse(url));
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Could not launch $url')),
                                    );
                                  }
                                },
                                child: Text(
                                  snapshot.data![index].url,
                                  style: const TextStyle(color: Colors.blue),
                                ),
                              )

                            ],
                          ),
                         SizedBox(height: 10),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Row(
                               children: [
                                 Icon(Icons.thumb_up,
                                   color: Colors.green,
                                 ),
                                 SizedBox(width: 20),
                                 Icon(Icons.thumb_down,
                                   color: Colors.green,

                                 ),
                               ],
                             ),

                             Icon(Icons.comment,
                             color: Colors.green,
                             ),
                           ],
                         )



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
  final String urlToImage;
  final String content;
  final String url;




  Player({
    required this.title,
    required this.urlToImage,
    required this.content,
    required this.url,



  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
        title: json['title'] ?? 'No Title',
      urlToImage: json['urlToImage'] ?? 'No Url',
      content: json['content'] ?? 'No Content',
      url: json['url'] ?? 'No Link',

    );

  }
}

void main() {
  runApp(MaterialApp(
    home: News(),
  ));
}
