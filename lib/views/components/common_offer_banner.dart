import 'package:flutter/material.dart';
import 'package:nectar_app/models/globals/globals.dart';
import 'package:nectar_app/utils/screens_path.dart';

class CommonOfferBanner extends StatelessWidget {
  final String offerName;
  final String name;

  const CommonOfferBanner(
      {required this.name, required this.offerName, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          offerName,
          style: const TextStyle(
            fontSize: 23,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              ScreensPath.exploreProductScreen,
              arguments: name,
            );
          },
          child: Text(
            "See all",
            style: TextStyle(
              color: Globals.greenColor,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
