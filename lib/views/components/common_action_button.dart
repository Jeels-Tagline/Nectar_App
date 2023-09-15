import 'package:flutter/material.dart';

class CommonActionButton extends StatelessWidget {
  final String name;
  const CommonActionButton({required this.name, super.key});

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Container(
      height: h * 0.07,
      width: w ,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xff53B175),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        name,
        style: const TextStyle(
          fontSize: 17,
          color: Colors.white,
        ),
      ),
    );
  }
}
