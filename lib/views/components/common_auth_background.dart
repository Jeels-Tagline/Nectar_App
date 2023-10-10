// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:nectar_app/utils/images_path.dart';

class CommonAuthBackground extends StatelessWidget {
  Widget? child;
  CommonAuthBackground({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ImagesPath.authBackground),
          fit: BoxFit.cover,
        ),
      ),
      child: child,
    );
  }
}
