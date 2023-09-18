import 'package:flutter/material.dart';
import 'package:nectar_app/utils/images_path.dart';

class CommonAuthBackground extends StatelessWidget {
  const CommonAuthBackground({super.key});

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Container(
      height: h,
      width: w,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ImagesPath.authBackground),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
