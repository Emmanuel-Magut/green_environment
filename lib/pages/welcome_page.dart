import 'package:flutter/material.dart';



class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: Column(
          children: [
            const SizedBox(height:150),
            Image.asset('lib/images/fitness1.png',
              height: 300,
            ),
            const SizedBox(height: 30),

            const Column(
              children: [
                Text('Make Your Body',
                  style: TextStyle(
                    fontSize: 40,
                    color: Colors.black,
                    fontFamily:'Georgia',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height:10),
                Text('Healthy & Fit',
                  style: TextStyle(
                    fontSize: 35,
                    color: Colors.deepPurple,
                    fontFamily: 'Georgia',
                    fontWeight: FontWeight.bold,
                  ),
                ),

              ],
            ),
            const SizedBox(height: 25,),
            const Column(
              children: [
                Text('Your number One Health and Wellness Hub',
                    style:TextStyle(
                      fontSize: 20,
                    )
                ),
                SizedBox(height: 5,),
                Text('Track your fitness journey',
                  style:TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height:60),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 120),
              child: GestureDetector(
                onTap: () {

                },
                child: Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.deepPurple,
                  ),
                  child: const Center(child: Text('Get Started',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
