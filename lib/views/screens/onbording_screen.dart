// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:nectar_app/main.dart';
import 'package:nectar_app/views/components/common_action_button.dart';
import 'package:nectar_app/views/components/common_small_body_text.dart';

class OnBordingScreen extends StatefulWidget {
  const OnBordingScreen({super.key});

  @override
  State<OnBordingScreen> createState() => _OnBordingScreenState();
}

class _OnBordingScreenState extends State<OnBordingScreen> {
  bool loggedIn = false;

  checkLogin() async {
   
    loggedIn = sharedPreferences!.getBool('isLoggedIn') ?? false;
    if (loggedIn == true) {
      Navigator.pushNamedAndRemoveUntil(
          context, 'home_screen', (route) => false);
    } else {
      Navigator.pushNamed(context, 'login_screen');
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        height: h,
        width: w,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.jpeg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          height: h,
          alignment: Alignment.bottomCenter,
          color: Colors.black.withOpacity(0.5),
          child: SizedBox(
            height: h / 2,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: h * 0.08,
                left: w * 0.045,
                right: w * 0.045,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: h * 0.07,
                    child: Image.asset("assets/logos/carot_white.png"),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: h * 0.02),
                    child: const Text(
                      "Welcome",
                      style: TextStyle(
                        fontSize: 45,
                        fontFamily: 'Gilroy-Medium',
                        height: 0.9,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: h * 0.01),
                    child: const Text(
                      "to our store",
                      style: TextStyle(
                        fontSize: 45,
                        fontFamily: 'Gilroy-Medium',
                        height: 0.2,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: h * 0.03),
                    child: const CommonSmallBodyText(
                      text: "Get your groceries in as fast as one hour",
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: h * 0.03),
                    child: GestureDetector(
                      onTap: () {
                        checkLogin();
                      },
                      child: const CommonActionButton(name: "Get Started"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
