import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:green_environment/Donations/mpesa_donations.dart';
import 'package:green_environment/GreenCommunity/green_community.dart';
import 'package:green_environment/events/total_trees.dart';
import 'package:green_environment/events/tracking_impact.dart';
import 'package:green_environment/events/treeplanting_events.dart';
import 'package:green_environment/pages/sections.dart';
import 'package:green_environment/pages/weather.dart';
import 'package:green_environment/sections/climate_education.dart';
import 'package:green_environment/sections/geolocation.dart';
import '../events/garbagecollection_events.dart';
import '../sections/carbon_section.dart';

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
    return SingleChildScrollView(
      child: Column(
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
                    MaterialPageRoute(builder: (context) =>   const ShowWeather(),
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
     const   SizedBox(height:20),
        //green community

       Padding(
         padding: const EdgeInsets.symmetric(horizontal: 20),
         child: Material(
           elevation: 10,
           borderRadius: BorderRadius.circular(12),
           child: Container(
             padding: const EdgeInsets.symmetric(horizontal: 10),
             decoration: BoxDecoration(
               borderRadius: BorderRadius.circular(12),
               border: Border.all(
                 width: 2,
                 color: Colors.green,
               )
             ),
             child: Column(
               children: [
                 const Row(
                   children: [
                     Text("Green Community",
                       style: TextStyle(
                         fontWeight: FontWeight.bold,
                         fontSize: 20,
                         color: Colors.green,
                         fontFamily: "Literata",
                       ),
                     )
                   ],
                 ),
                 const SizedBox(height: 10),
                 const Text("Inspire others by sharing your experiences, "
                     "tips, and knowledge about green living. "
                     "Create short, engaging posts to raise "
                     "awareness and spark meaningful conversations.",
                 style: TextStyle(
                   fontSize: 16,
                 ),
                 ),
                 Image.asset("lib/images/community.png",
                 height: 180,
                 ),
                const SizedBox(height:10),
                 Padding(
                   padding: const EdgeInsets.all(12.0),
                   child: Container(
                     padding: const EdgeInsets.only(left: 20, right:20, top:10, bottom: 10),
                     decoration: BoxDecoration(
                       color: Colors.green,
                       borderRadius: BorderRadius.circular(14),
                     ),
                     child: GestureDetector(
                       onTap:(){
                         Navigator.pushReplacement(
                             context,
                           MaterialPageRoute(builder: (context) => const GreenCommunity()
                           ),
                         );
                       },
                       child: const Text("Join Community",
                       style: TextStyle(
                         color: Colors.white,
                         fontSize: 22,
                         fontWeight: FontWeight.bold,
                       ),
                       ),
                     ),
                   ),
                 )
               ],
             ),
           ),
         ),
       ),

       const SizedBox(height: 40),
        //donate funds
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Material(
            elevation: 10,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    width: 2,
                    color: Colors.green,
                  )
              ),
              child: Column(
                children: [
                  const Row(
                    children: [
                      Text("Donate Funds",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.green,
                          fontFamily: "Literata",
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text("Join us in supporting a healthier planet by donating "
                      "to various environmental causes. Every contribution,"
                      " big or small, plays a crucial role in protecting "
                      "our Earth for future generations.",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),

                  const Text("Your Contribution Will help us in:",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  ),
                  const Text("Supporting initiatives that plant trees, restore forests, and combat deforestation.",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                  ),
                  const SizedBox(height: 4),
                  const Text("support various environmental projects focused on climate change, waste reduction, and community education.",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text("Various Tree planting and garbage collection exercises aimed at keeping our planet greener and cleaner",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Image.asset("lib/images/donate.png",
                    height: 180,
                  ),
                  const SizedBox(height:10),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      padding: const EdgeInsets.only(left: 20, right:20, top:10, bottom: 10),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: GestureDetector(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>const MpesaDonations()
                            ),

                          );
                        },
                        child: const Text("Donate Now!",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),



        const SizedBox(height: 20),
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
        const SizedBox(height:20),
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            //tree planting
            GestureDetector(
              onTap:(){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TreePlantingEvents()),
                );
      },
              child: Container(
                height: 120,
                width: 200,
                decoration:  BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.green,
                    )
                ),
                child: Column(
                  children: [
                    Image.asset('lib/images/plantings.png',
                      height: 70,
                    ),
                    const Text("Tree Planting",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //garbage collections
            GestureDetector(
              onTap:(){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CleanUpEvents()),
                );
              },
              child: Container(
                height: 130,
                width: 200,
                decoration:  BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.green,
                    )
                ),
                child: Column(
                  children: [
                    Image.asset('lib/images/wastes.png',
                      height: 70,
                    ),
                    const Text("Garbage Collections",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

        //total trees planted
        GestureDetector(
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TreesPlantedByCountyChart())
            );

          },
          child: Container(
           height: 120,
           child:const TreesPlanted(),
          ),
        ),
        //total waste collected



      ],
      ),
    );
  }

  //function to fetch the total number of trees planted
  Future<int> getTotalTreesPlanted() async {
    int totalTreesPlanted = 0;

    // Query the upcoming_events collection
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('upcoming_events').get();

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



}
