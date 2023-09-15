import 'package:flutter/material.dart';
import 'package:nectar_app/utils/screens_path.dart';
import 'package:nectar_app/views/components/common_action_button.dart';
import 'package:nectar_app/views/components/common_auth_background.dart';
import 'package:nectar_app/views/components/common_small_body_text.dart';
import 'package:nectar_app/views/components/common_title_text.dart';

class OrderAcceptedScreen extends StatefulWidget {
  const OrderAcceptedScreen({super.key});

  @override
  State<OrderAcceptedScreen> createState() => _OrderAcceptedScreenState();
}

class _OrderAcceptedScreenState extends State<OrderAcceptedScreen> {
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          const CommonAuthBackground(),
          Padding(
            padding:
                EdgeInsets.only(top: h * 0.2, left: w * 0.04, right: w * 0.04),
            child: Center(
              child: Column(
                children: [
                  Image.asset("assets/images/sucess.png"),
                  Padding(
                    padding: EdgeInsets.only(top: h * 0.08),
                    child: const CommonTitleText(
                      title: "Your Order has been\n accepted",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: h * 0.04),
                    child: const CommonSmallBodyText(
                      text:
                          "Your items has been placed and is on it's way to begin processed",
                      color: Colors.grey,
                      align: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: h * 0.08),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamedAndRemoveUntil(
                            context, ScreensPath.homeScreen, (route) => false);
                      },
                      child: const CommonActionButton(
                        name: "Track Order",
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: h * 0.02),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamedAndRemoveUntil(
                            context, ScreensPath.homeScreen, (route) => false);
                      },
                      child: const Text(
                        "Back to home",
                        style: TextStyle(
                          fontSize: 18,
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
    );
  }
}
