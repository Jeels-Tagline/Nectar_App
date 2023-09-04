import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nectar_app/views/screens/onbording_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  nextPage() {
    Timer(
      const Duration(seconds: 3),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const OnBordingScreen(),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    nextPage();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        height: h,
        width: w,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: Color(0xff53B175),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: h * 0.08,
              child: Image.asset("assets/logos/carot_white.png"),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: SizedBox(
                height: h * 0.08,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "nectar",
                      style: TextStyle(
                        fontSize: 55,
                        height: 1,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "online groceriet",
                      style: TextStyle(
                        height: 1,
                        fontFamily: 'Gilroy-Medium',
                        letterSpacing: 3.9,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}