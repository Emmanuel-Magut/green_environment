
import 'package:flutter/material.dart';
import 'package:green_environment/pages/sections.dart';
import 'package:green_environment/pages/weather.dart';
import 'package:green_environment/sections/carbon_footprint.dart';
import 'package:green_environment/sections/climate_education.dart';
import 'package:green_environment/sections/geolocation.dart';

import '../sections/carbon_section.dart';
import '../sections/weather.dart';
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  //cycling content
void cycling(){
  showDialog(context: context, builder: (context){
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Column(
        children: [
          GestureDetector(
            onTap: close,
            child: const Icon(Icons.cancel_outlined,
              size: 48,
              color: Colors.red,
            ),
          ),
          Image.asset("lib/images/cycling.png",
          height: 140,
          ),
          const SizedBox(height: 5),

          const Text("Choosing to cycle or walk for short distances "
              "instead of using motorized transportation is an "
              "excellent eco-friendly option. "
              "It reduces carbon emissions, promotes personal health,"
              " and contributes to a cleaner environment.",
            style: TextStyle(
              fontSize: 20,
            ),
          )
        ],
      ),
    );
  });
}
  //waste recycling content
void recycling(){
  showDialog(context: context, builder: (context){
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Column(
        children: [
          GestureDetector(
            onTap: close,
            child: const Icon(Icons.cancel_outlined,
              size: 48,
              color: Colors.red,
            ),
          ),
          Image.asset("lib/images/recycling.png",
            height: 140,
          ),
          const SizedBox(height: 5),

          const Text("Waste recycling is eco-friendly as it helps "
              "reduce the strain on natural resources and lessens "
              "environmental pollution. Instead of disposing off used "
              "materials, recycling involves transforming them into new products. "
              "This process minimizes the need for extracting and processing fresh raw materials,"
              " conserving energy and lowering greenhouse gas emissions. By embracing recycling,"
              " we contribute to a more sustainable and circular economy, where materials are reused, "
              "promoting environmental health and reducing the burden on landfills.",
            style: TextStyle(
              fontSize: 20,
            ),


          )
        ],
      ),
    );
  });
}
  //plant-based diet content
void diet(){
  showDialog(context: context, builder: (context){
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Column(
        children: [
          GestureDetector(
            onTap: close,
            child: const Icon(Icons.cancel_outlined,
              size: 48,
              color: Colors.red,
            ),
          ),
          Image.asset("lib/images/diets.png",
            height: 160,
          ),
          const SizedBox(height: 5),

          const Text("Choosing a plant-based diet is an eco-friendly activity "
              "with positive impacts on the environment. Plant-based diets, "
              "focused on fruits, vegetables, legumes, and whole grains, have"
              " a lower carbon footprint compared to diets high in animal products. "
              "They require less land, water, and result in fewer greenhouse gas emissions."
              " Opting for plant-based alternatives helps reduce deforestation, habitat destruction,"
              " and pollution linked to industrial animal agriculture. "
              "This dietary choice supports biodiversity, conserves resources, "
              "and aligns with sustainable practices, making it a simple yet impactful way "
              "to contribute to a healthier planets.",
            style: TextStyle(
              fontSize: 20,
            ),
          )
        ],
      ),
    );
  });
}
//Alert closing box
 void close(){
  Navigator.pop(context);
 }
  @override
  Widget build(BuildContext context) {
    return Column(
    children: [
    //welcome banner
    Material(
      elevation: 10.0,
      borderRadius: const BorderRadius.only(
        bottomRight: Radius.circular(40),
        bottomLeft: Radius.circular(40),
      ),
      child: Container(
      height: 200,
      decoration: const BoxDecoration(
      color: Colors.green,
      borderRadius: BorderRadius.only(
      bottomRight: Radius.circular(40),
      bottomLeft: Radius.circular(40),
      ),
      ),
        child: Row(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.asset("lib/images/banner.jpg",
                      height: 120,

                    ),
                  ),
                ),
                const SizedBox(width:2),
                Container(
                  padding:const EdgeInsets.symmetric(horizontal: 25),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Twende Green,",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          fontFamily: "Georgia",
                        ),

                      ),
                      SizedBox(height: 10),
                      Text("Uniting for a Cleaner,",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          fontFamily: "Georgia",
                        ),
                      ),
                      SizedBox(height: 10),
                      Text("Greener Planet.",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          fontFamily: "Georgia",
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    ),
    //Sections
const SizedBox(height: 5),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Material(
              elevation:10,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(4),
                child: const Text("Sections",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.green,
                  fontFamily: "Literata",
                ),
                ),
              ),
            ),


          ],
        ),
      ),
      const SizedBox(height:5),
      //Sections
      Container(
        height: 155,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            SectionsContainer(
              imagePath: "lib/images/weather.png",
              text: "My Weather Today",
              onTap: (){

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>   const WeatherWidget(),
                  ),
                );
              },
            ),
            SectionsContainer(
              imagePath: "lib/images/education.png",
              text: "Climate change Education",
              onTap: (){
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const ClimateEducation(),
                  ),
                );
              },
            ),
            SectionsContainer(
              imagePath: "lib/images/geolocation.png",
              text: "Geolocation Services",
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GeolocationServices(),
                  ),
                );
              },
            ),
            SectionsContainer(
              imagePath: "lib/images/carbon.png",
              text: "Carbon Footprints Calculator",
              onTap: (){
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const CarbonSection(),
                  ),
                );
              },
            ),
          ],
        ),
      ),

      //Eco-friendly activities
      const SizedBox(height: 5),
      Row(
        children: [
          Material(
            elevation: 10.0,
            borderOnForeground: false,
            borderRadius: BorderRadius.circular(12.0),
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal:25),
                child: const Text("Eco-friendly Activities",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.green,
                    fontFamily: "Literata",
                  ),
                ),
            ),
          ),
        ],
      ),
      const SizedBox(height:10),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          //1st container
          Material(
            elevation: 10.0,
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white54,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: Colors.green,
                  width: 2,
                ),
              ),

              child: Column(
                children: [
                  Image.asset("lib/images/cycling.png",
                  height: 80,
                  ),
                  const SizedBox(height: 15),
                  const Text("Cycling",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  ),
                  const SizedBox(height: 5,),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: GestureDetector(
                      onTap: cycling,
                      child: const Text("Read More",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          //Second container
          Material(
            elevation: 10.0,
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white54,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: Colors.green,
                  width: 2,
                ),
              ),

              child: Column(
                children: [
                  Image.asset("lib/images/recycling.png",
                    height: 70,
                  ),
                  const SizedBox(height: 10),
                  const Text("Waste",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text("Recycling",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5,),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: GestureDetector(
                      onTap: recycling,
                      child: const Text("Read More",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          //Third container
          Material(
            elevation: 10.0,
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white54,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: Colors.green,
                  width: 2,
                ),
              ),

              child: Column(
                children: [
                  Image.asset("lib/images/diets.png",
                    height: 68,
                  ),
                  const SizedBox(height: 20),
                  const Text("plant-based",
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text("diet",
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5,),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: GestureDetector(
                      onTap: diet,
                      child: const Text("Read More",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

        ],
      ),
      const SizedBox(height: 5),
      //events
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child:  Row(
          children: [
            Material(
              elevation:10.0,
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.all(4),
                child: const Text("Events",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                  fontSize: 20,
                  fontFamily: "Literata",
                ),
                ),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height:5),
      Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: ListView(
              scrollDirection: Axis.vertical,
              children: [
                //1st container
                 Material(
                   elevation:10.0,
                   borderRadius: BorderRadius.circular(20),
                   child: Container(
                     padding: const EdgeInsets.all(8),
                     decoration: BoxDecoration(
                       border: Border.all(
                         color: Colors.green,
                       ),
                       color: Colors.white10,
                       borderRadius: BorderRadius.circular(20),
                     ),
                     child: Row(
                       crossAxisAlignment: CrossAxisAlignment.center,
                       children: [
                         Image.asset("lib/images/plantings.png",
                           height:74,
                         ),
                         const SizedBox(width: 10),
                         const Text("Tree Planting",
                         style: TextStyle(
                           fontWeight: FontWeight.bold,
                           fontSize: 19,
                         ),
                         ),
                         const SizedBox(width: 10),
                         Container(
                           padding: const EdgeInsets.all(12),
                           decoration: BoxDecoration(
                             color: Colors.green,
                             borderRadius:BorderRadius.circular(12),
                           ),
                           child: const Text("check Events",
                           style: TextStyle(
                             fontWeight: FontWeight.bold,
                             color: Colors.white,
                             fontSize: 18,
                           ),
                           ),
                         )
                       ],
                     ),
                   ),
                 ),
                //Second container
                const SizedBox(height: 5),
                Material(
                  elevation: 10.0,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.green,
                      ),
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset("lib/images/wastes.png",
                          height:61,
                        ),
                        const Text("Garbage Collection",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius:BorderRadius.circular(12),
                          ),
                          child: const Text("check Events",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 17,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                //Third container
                Material(
                  elevation: 10.0,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.green,
                      ),
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset("lib/images/summits.png",
                          height:61,
                        ),
                        const Text("Climate Summits",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        const SizedBox(width:4),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius:BorderRadius.circular(12),
                          ),
                          child: const Text("check Events",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 17,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                //Fourth container
              ],
            ),
          )
      ),
    ],
    );
  }
}
