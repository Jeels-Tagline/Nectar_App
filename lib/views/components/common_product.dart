import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nectar_app/models/globals/globals.dart';

class CommonProduct extends StatelessWidget {
  final String image;
  final String name;
  final String subTitle;
  final String price;
  const CommonProduct({
    super.key,
    required this.image,
    required this.name,
    required this.subTitle,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Container(
      height: h * 0.26,
      width: w * 0.4,
      padding: EdgeInsets.only(
        top: h * 0.01,
        bottom: h * 0.01,
        left: w * 0.01,
        right: w * 0.01,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: h * 0.1,
              width: w,
              child: Image.memory(
                base64Decode(image),
              ),
            ),
            Text(
              name,
              style: const TextStyle(
                fontSize: 17,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              subTitle,
              style: TextStyle(
                fontSize: 13,
                fontFamily: 'Gilroy-Medium',
                color: Colors.grey.shade500,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: h * 0.013),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "\$ $price",
                      style: const TextStyle(
                        fontSize: 17,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Container(
                    height: h * 0.055,
                    width: w * 0.12,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Globals.greenColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(
                      Icons.add,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
