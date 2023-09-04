import 'package:flutter/material.dart';

class CommonTitleText extends StatelessWidget {
  final String title;
  const CommonTitleText({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 25,
        height: 1,
      ),
    );
  }
}
