import 'package:flutter/material.dart';
import 'package:nectar_app/models/globals/globals.dart';
import 'package:nectar_app/utils/screens_path.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CommonOfferBanner extends StatelessWidget {
  final String offerName;
  final String name;
  // final String showTitle;

  const CommonOfferBanner(
      {required this.name, required this.offerName, super.key});

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.only(
        left: w * 0.05,
        right: w * 0.05,
      ),
      child: Row(
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
              Map<String, dynamic> data = {
                'name': name,
                'showTitle': offerName,
              };
              Navigator.pushNamed(
                context,
                ScreensPath.exploreProductScreen,
                arguments: data,
              );
            },
            child: Text(
              AppLocalizations.of(context)!.seeAll,
              style: TextStyle(
                color: Globals.greenColor,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
