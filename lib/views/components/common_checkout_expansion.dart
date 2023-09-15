import 'package:flutter/material.dart';

class CommonChechoutExpansion extends StatelessWidget {
  final String title;
  final Widget? widget;
  final String? subTitle;
  const CommonChechoutExpansion({
    required this.title,
    this.subTitle,
    this.widget,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Column(
      children: [
        SizedBox(
          height: h * 0.04,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              Row(
                children: [
                  if (subTitle != null) Text(subTitle!),
                  if (widget != null) widget!,
                  SizedBox(
                    width: w * 0.015,
                  ),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 18,
                  ),
                ],
              ),
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }
}
