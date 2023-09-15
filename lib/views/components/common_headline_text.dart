import 'package:flutter/material.dart';

class CommonHeadlineText extends StatelessWidget {
  final String title;
  const CommonHeadlineText({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 22,
        height: 1,
      ),
    );
  }
}
