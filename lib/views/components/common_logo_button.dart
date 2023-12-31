import 'package:flutter/material.dart';
import 'package:nectar_app/utils/font_family.dart';

class CommonLogoButton extends StatelessWidget {
  final String logo;
  final String name;
  final Color color;
  const CommonLogoButton({
    required this.logo,
    required this.name,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Container(
      height: 62,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 19,
            child: SizedBox(
              height: 25,
              width: w * 0.2,
              child: Image.asset(logo),
            ),
          ),
          Center(
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 17,
                fontFamily: FontFamily.medium,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
