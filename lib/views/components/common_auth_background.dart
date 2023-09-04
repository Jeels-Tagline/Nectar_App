import 'package:flutter/material.dart';

class CommonAuthBackground extends StatelessWidget {
  const CommonAuthBackground({super.key});

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Container(
      height: h,
      width: w,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/auth_background.png"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
