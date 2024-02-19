import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:green_environment/models/players.dart';

import 'package:http/http.dart' as http;

import '../models/team.dart';

class NBA extends StatelessWidget {
  NBA({super.key});

  List<Team> teams = [];
  //Get Teams
  Future getTeams() async {
    var response = await http.get(Uri.https('balldontlie.io', 'api/v1/teams'));

    var jsonData = jsonDecode(response.body);
    for(var eachTeam in jsonData['data']){
      final team = Team(abbreviation: eachTeam['abbreviation'],
        city:eachTeam['city'],
        conference: eachTeam['conference'],
        division: eachTeam['division'],
      );
      teams.add(team);
    }
    print(teams.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("NBA TEAMS",
          style: TextStyle(
            fontSize: 24,
            fontFamily: 'Literata',
          ),
        ),
        backgroundColor: Colors.pink,
      ),
      body: FutureBuilder(
        future: getTeams(),
        builder: (context, snapshot) {
          //is it done loading? then show team data
          if (snapshot.connectionState == ConnectionState.done){
            return ListView.builder(
                itemCount: teams.length,
                itemBuilder: (context, index){
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(teams[index].abbreviation),
                      Text(teams[index].city),
                      Text(teams[index].conference),
                      Text(teams[index].division),


                    ],
                  );
                }
            );

          }
          // if it's still loading, show loading circle
          else{
            return Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            );
          }
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context)=> Players()),
              );
            }, icon: Icon(Icons.sports_basketball,
              size: 65,
            ),
              tooltip: 'Players',
            )
          ],
        ),
      ),
    );
  }
}
