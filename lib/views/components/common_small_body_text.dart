import 'package:flutter/material.dart';
import 'package:nectar_app/utils/font_family.dart';

class CommonSmallBodyText extends StatelessWidget {
  final String text;
  final Color color;
  final TextAlign? align;

  const CommonSmallBodyText({
    required this.text,
    required this.color,
    super.key,
    this.align,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      textAlign: align,
      text,
      style: TextStyle(
        fontSize: 15,
        fontFamily: FontFamily.medium,
        color: color,
      ),
    );
  }
}
