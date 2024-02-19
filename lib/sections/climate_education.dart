import 'package:flutter/material.dart';
import 'package:green_environment/pages/home_page.dart';

class ClimateEducation extends StatefulWidget {
  const ClimateEducation({super.key});

  @override
  State<ClimateEducation> createState() => _ClimateEducationState();
}

class _ClimateEducationState extends State<ClimateEducation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child:  Column(
                children: [
                  SizedBox(height: 20),
                 Text("Welcome, Green Guardians!",
                 style: TextStyle(
                   fontSize: 22,
                   fontFamily: "Literata",
                   fontWeight: FontWeight.bold,
                 ),
                 ),
              SizedBox(height: 10),
                  Image.asset("lib/images/planA.png",
                    height: 170,
                  ),
                  SizedBox(height: 10),
                  Text("Hey there, fellow nature enthusiasts! "
                      "Ready to dig into the big topic of our time – climate change?"
                      " Let's make this journey fun and easy.",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: "Literata",
                    ),
                  ),
                  SizedBox(height: 20),




                  Text("Feeling the Heat: Earth's Cozy Blanket",
                    style: TextStyle(
                      fontSize: 22,
                      fontFamily: "Literata",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  //Second Heading
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("lib/images/greenhouse.png",
                      height: 170,
                      ),

                    ],
                  ),
                  Text("Think of Earth as a snug little house, warmed up by sunshine. "
                      "But here's the twist – special gases like CO2 and methane act "
                      "like a cozy blanket, trapping heat and making our home a bit "
                      "too toasty. This is what we call the greenhouse effect.",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: "Literata",
                    ),
                  ),

                 SizedBox(height: 20,),

                  Text("Let's Break It Down:",
                    style: TextStyle(
                      fontSize: 19,
                      fontStyle: FontStyle.italic,
                      fontFamily: "Literata",
                    ),
                  ),//Subheading
                  Text("Imagine you're in a sunbeam-filled room, and the curtains are these gases,"
                      " playing a role in keeping the warmth inside. It's like a nature-themed mystery,"
                      " with us as the detectives.",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: "Literata",
                    ),
                  ),

                 SizedBox(height: 20,),

                  Text("Weather Play vs. Climate Story: Unraveling the Patterns",
                    style: TextStyle(
                      fontSize: 22,
                      fontFamily: "Literata",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  //Heading
                  SizedBox(height: 10),
                  Image.asset("lib/images/weathers.jpg",
                    height: 170,
                  ),
                  SizedBox(height: 10),
                  Text("Don't let a sudden rain shower fool you – that's just everyday weather being a bit moody."
                      " Climate, though, is like the director of a long-term movie, showing us the average "
                      "temperature over many years. Climate change is like a little kid having a years-long "
                      "tantrum, causing some lasting issues.",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: "Literata",
                    ),
                  ),
                  SizedBox(height: 10,),
                  Text("Let's Play Detective:",
                    style: TextStyle(
                      fontSize: 19,
                      fontFamily: "Literata",
                      fontStyle: FontStyle.italic,
                    ),
                  ),//subheading
                  Text("Grab your magnifying glass as we decipher the clues between a quick rainstorm and the"
                      " bigger story of climate change. We're like Sherlock Holmes, but for the environment!",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: "Literata",
                    ),
                  ),

                  SizedBox(height: 20,),

                  Text("Who's the Trouble Maker? Humans vs. Nature",
                    style: TextStyle(
                      fontSize: 22,
                      fontFamily: "Literata",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  //Header
                  SizedBox(height: 10),
                  Image.asset("lib/images/who.png",
                    height: 190,
                  ),
                  SizedBox(height: 10),
                  Text("Now, let's find out who's causing all this trouble – surprise, it's us! Human activities"
                      " take the spotlight as we burn fossil fuels like coal and oil, letting out lots of CO2, the"
                      " troublemaker. Cutting down trees (deforestation) makes things worse, and industries add their"
                      " share of heat-trapping gases.",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: "Literata",
                    ),
                  ),

                  SizedBox(height: 20),
                  Text("Connect the Dots:",
                    style: TextStyle(
                      fontSize: 19,
                      fontFamily: "Literata",
                      fontStyle: FontStyle.italic,
                    ),
                  ),//Subheading
                  Text("Picture it like connecting dots on a detective board. Our actions add up, making Earth warmer. "
                      "But don't worry, we can turn things around.",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: "Literata",
                    ),
                  ),

                    SizedBox(height: 20),
                  Text("The Hot Consequences: Facing the Results",
                    style: TextStyle(
                      fontSize: 22,
                      fontFamily: "Literata",
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  //Heading
                  SizedBox(height: 10),
                  Image.asset("lib/images/effects.png",
                    height: 190,
                  ),
                  SizedBox(height: 10),
                  Text("As Earth warms up, there are consequences. Sea levels rise, storms get stronger, and plants and animals struggle to cope. "
                      "It's like a chain reaction of problems coming from a warmer world.",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: "Literata",
                    ),
                  ),
                  SizedBox(height: 20),
                  Text("Let's Be Real:",
                    style: TextStyle(
                      fontSize: 19,
                      fontFamily: "Literata",
                      fontStyle: FontStyle.italic,
                    ),
                  ),//Subtopic
                  Text("It's a bit scary, but here's the good part – being aware is the first step to fixing things."
                      " We've got this, Green Guardians!",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: "Literata",
                    ),
                  ),
                  SizedBox(height: 20),
                  Text("But wait, Green Guardians! We're not powerless!",
                    style: TextStyle(
                      fontSize: 22,
                      fontFamily: "Literata",
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  //Heading
                  SizedBox(height: 10),
                  Image.asset("lib/images/powerful.png",
                    height: 190,
                  ),
                  SizedBox(height: 10),
                  Text("Here's the exciting part – we can make a difference! Using clean energy like sunlight "
                      "and wind, planting trees, cutting down on waste, and making good choices in our daily"
                      " lives turn us into Earth heroes, fighting for a cooler and healthier home.",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: "Literata",
                    ),
                  ),
                  SizedBox(height: 20),
                  Text("Empower Yourself:",
                    style: TextStyle(
                      fontSize: 19,
                      fontFamily: "Literata",
                      fontStyle: FontStyle.italic,
                    ),
                  ),//subheading
                  Text("Knowledge is power, so let's gather some and take small steps. Each little thing we do "
                      "adds up to a big change. Ready to be a Green Guardian superhero?",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: "Literata",
                    ),
                  ),
                  SizedBox(height: 20),
                  Text("Remember, every action counts! Join the Green Guardians, share the word, and let's make a difference together!",
                    style: TextStyle(
                      fontSize: 22,
                      fontFamily: "Literata",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  //Heading
                  SizedBox(height: 10),
                  Image.asset("lib/images/people.png",
                    height: 270,
                  ),
                  SizedBox(height: 10),
                  Text("So, Green Guardians, are you ready for this awesome adventure? Let's spread the "
                      "excitement and get others on board. Together, we're a force to be reckoned with for good!",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: "Literata",
                    ),
                  ),
                  SizedBox(height: 20),

                  Text("Great Job, Green Guardian!",
                  style: TextStyle(
                    fontFamily:"Pacifico",
                    fontSize: 26,
                  ),
                  ), //Subheading
                  SizedBox(height: 10),
                  Image.asset("lib/images/good.png",
                    height: 270,
                  ),
                  SizedBox(height: 10),
                  Text("By diving into the world of climate change, you're making a big difference. "
                      "Your interest and effort are fantastic, and as you keep going, know that every "
                      "little thing you do helps. Stay motivated, stay informed, and let's take on the "
                      "challenge of climate change together! You rock!",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: "Literata",
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child:Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(onPressed:(){
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()
                ),
              );
            } , icon: const Icon(Icons.home,
            size: 50,
              color: Colors.green,
            ),
              tooltip: "Home",
              color: Colors.black,

            ),
          ],
        )
      ),
    );
  }
}
