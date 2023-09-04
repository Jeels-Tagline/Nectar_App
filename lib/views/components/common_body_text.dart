import 'package:flutter/material.dart';

class CommonBodyText extends StatelessWidget {
  final String text;
  const CommonBodyText({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 15,
        color: Color(0xff7C7C7C),
      ),
    );
  }
}
