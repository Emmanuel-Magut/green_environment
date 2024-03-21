import 'package:flutter/material.dart';
import 'package:green_environment/pages/home_page.dart';
import 'package:green_environment/pages/intro_screens/intro_page1.dart';
import 'package:green_environment/pages/intro_screens/intro_page2.dart';
import 'package:green_environment/pages/intro_screens/intro_page3.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  //controller to keep track of the page we are in
  PageController _controller = PageController();
  //check if we are on the last page or not
  bool onLastPage = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          //pageview
          PageView(
            onPageChanged: (index){
              setState(() {
                onLastPage = (index == 2);
              });
            },
            controller: _controller,
            children: const [
             IntroPage1(),
              IntroPage2(),
              IntroPage3(),
            ],
          ),

          //dot indicators
          Container(
            alignment: Alignment(0,0.85),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //skip
                  GestureDetector(
                    onTap:(){
                      _controller.jumpToPage(2);
                    },
                      child: Container(
                        padding: const EdgeInsets.only(top:10, bottom: 10, left: 20, right: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                          child: const Text('Skip',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                          )
                      ),
                  ),
                  //dot indicator
                  SmoothPageIndicator(
                      controller: _controller,
                      count: 3,
                  ),
                  //next or done
                  onLastPage?
                  GestureDetector(
                    onTap:(){
                     Navigator.pushReplacement(
                         context,
                         MaterialPageRoute(builder: (context) => const HomePage())
                     );

                    },
                      child: Container(
                          padding: const EdgeInsets.only(top:10, bottom: 10, left: 20, right: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text('Get Started',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          )
                      ),
                  ): GestureDetector(
                  onTap:(){
    _controller.nextPage(
    duration: const Duration(milliseconds: 500),
    curve: Curves.easeIn,
    );
    },
    child: Container(
        padding: const EdgeInsets.only(top:10, bottom: 10, left: 20, right: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text('Next',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        )
    ),
    ),
                ],
              )),
        ],
      )
    );
  }
}
