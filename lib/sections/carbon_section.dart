import 'package:flutter/material.dart';
import 'package:green_environment/pages/home_page.dart';
import 'package:green_environment/sections/carbon_footprint.dart';

class CarbonSection extends StatelessWidget {
  const CarbonSection({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(height:70),
              Image.asset("lib/images/footprints.png"),
              Text("Reduce Carbon Footprint, Save Our Planet.",

              style: TextStyle(
                fontSize: 28,
                fontFamily: "Lobster",
              ),
              ),
              SizedBox(height:20),
              Text("Calculate Your Carbon Emissions",
              style: TextStyle(
                fontSize: 20,
                fontFamily: "Pacifico",
              ),
              ),
              SizedBox(height:60),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //Travel
                  Column(
                    children: [
                      Image.asset("lib/images/travel.png",
                      height: 100,
                      ),
                      Text("Travel",
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: "Lobster",
                      ),
                      ),
                    ],
                  ),
                  //Food
                  Column(
                    children: [
                      Image.asset("lib/images/foods.png",
                        height: 100,
                      ),
                      Text("Food",
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: "Lobster",
                        ),
                      ),
                    ],
                  ),
                  //Energy
                  Column(
                    children: [
                      Image.asset("lib/images/energy.png",
                        height: 100,
                      ),
                      Text("Energy",
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: "Lobster",
                        ),
                      ),
                    ],
                  ),
                ],
              ),
               SizedBox(height:100),
               //button
              Container(
                padding: EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: GestureDetector(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FootprintCalculator()
                      ),
                    );
                  },
                  child: Text("Calculate",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  ),
                ),
              )
            ],

          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap:(){
               Navigator.pushReplacement(
                 context,
                 MaterialPageRoute(builder: (context) => const HomePage(),
                 ),
               );
            },
              child: Icon(Icons.home,
              size: 64,
                color: Colors.green,
              ),
            )
          ],
        ),
      ),
    );
  }
}
