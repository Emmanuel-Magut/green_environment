import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'home_page.dart';
import 'onboard.dart';
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final controller = PageController();
  bool isLastPage = false;
  @override
  void dispose(){
    controller.dispose();
        super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(bottom: 80),
          child: PageView(
            controller: controller,

            children: [
              Onboard(
                color: Colors.green,
                imagePath: ("lib/images/enviroment.png"),
                title: 'Twende Green Hub',
                subtitle: "Welcome to Twende Green Hub! 🌿 "
                    "We are thrilled to have you on board as part of our green community. "
                    "At Twende Green Hub, we believe in the power of collective action to "
                    "create a sustainable and eco-friendly future. On this platform, "
                    "you'll discover exciting opportunities to contribute to a greener "
                    "environment, connect with like-minded individuals, and access "
                    "valuable resources to promote sustainable living. Together, let's "
                    "embark on a journey towards a more environmentally conscious and vibrant world. "
                    "Thank you for joining Twende Green Hub – where every small action makes a big impact! 🌍💚",
              ),

              //second Container
             Onboard(
               color: Colors.green,
               imagePath: ("lib/images/plant.jpg"),
               title: 'Embrace the Power of Green,'
                   ' with Tree Planting 🌳',
               subtitle: "Join us in our mission to make a tangible impact on the environment "
                   "by actively participating in tree planting initiatives. Trees are the "
                   "lungs of our planet, absorbing carbon dioxide and providing us with oxygen."
                   " By planting trees, you contribute to cleaner air, a healthier ecosystem, "
                   "and a greener future for generations to come. Twende Green Hub offers exciting "
                   "opportunities to get your hands dirty and plant trees in various locations. "
                   "Let's grow a forest of positive change together and witness the transformative power of nature!",
             ),
              //Third container
              Onboard(
                color: Colors.green,
                imagePath: ("lib/images/waste.jpg"),
                title: 'Revolutionize Waste Management through Garbage Collection ♻️',
                subtitle: "In our commitment to building a sustainable future, "
                    "Twende Green Hub recognizes the crucial role of responsible waste management."
                    " Join us in the movement to clean up our surroundings and reduce our ecological footprint. "
                    "Engage in organized garbage collection events where every piece of litter collected"
                    " contributes to a cleaner, healthier environment. Through proper waste disposal and recycling initiatives, "
                    "we can protect our ecosystems, preserve natural resources, and create a cleaner, more vibrant world. "
                    "Together, let's turn waste into a valuable resource and lead the way towards a greener and more sustainable planet.",
              ),
              TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.green,
                  minimumSize: Size.fromHeight(80),
                ),
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),

                        ),
                          child: Image.asset("lib/images/planting.png"),
                      ),

                      SizedBox(height:100),
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Get Started',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                onPressed:() {

                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context)=> HomePage()),

                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomSheet: isLastPage? TextButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          foregroundColor: Colors.white,
          backgroundColor: Colors.green,
          minimumSize: Size.fromHeight(80),
        ),
        child: Text(
          'Get Started',
          style: TextStyle(fontSize: 24),
        ),
        onPressed:() async{
        final prefs = await SharedPreferences.getInstance();
        prefs.setBool('showHome',true);

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context)=> HomePage()),

          );
        },
      ):

      Container(
        padding: const EdgeInsets.symmetric(horizontal:5),
        height:80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
            onPressed: () => controller.jumpToPage(2),
                child: const Text('SKIP'),
            ),
            Center(
              child: SmoothPageIndicator(
                controller: controller,
                count:3,
                effect: WormEffect(
                  spacing: 16,
                  dotColor: Colors.green,
                  activeDotColor: Colors.blueGrey,
                ),
                onDotClicked: (index) => controller.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 500),

                    curve: Curves.easeIn),
              ),
            ),
            TextButton(
                onPressed: () => controller.nextPage(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                ),
                child: const Text('NEXT'),
            ),
          ],
        ),
      ),
    );
  }
}
