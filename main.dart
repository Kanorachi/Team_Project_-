import 'package:flutter/material.dart';
import 'home.dart'; // Ensure you have the home.dart file in the same directory

void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Car Rental App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WelcomePage(), // Set the WelcomePage as the home screen
    );
  }
}

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Background image
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('C:/flutter_mini/assets/imate.png'), // Background image path
                  fit: BoxFit.cover, // Cover the entire screen
                ),
              ),
            ),
            // Overlay to improve text readability
            Container(
              color: Colors.black54, // Semi-transparent overlay
            ),
            Column(
              children: [
                Expanded(
                  child: Container(), // Placeholder for the image
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Ultimate Car Rental Experience',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // White color for better contrast
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Travel comfortably with the car rental of your choice! Find and book the right car for you in one app.',
                        style: TextStyle(fontSize: 16, color: Colors.white70),
                      ),
                      SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(), // Ensure HomeScreen is defined in home.dart
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Text(
                            'Let\'s Get Started',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white, // Text color for better visibility
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
