import 'package:flutter/material.dart';
import 'package:nectar_app/models/globals/globals.dart';

class CommonOfferBanner extends StatelessWidget {
  final String offerName;

  const CommonOfferBanner({required this.offerName, super.key});

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
        Text(
          "See all",
          style: TextStyle(
            color: Globals.greenColor,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
