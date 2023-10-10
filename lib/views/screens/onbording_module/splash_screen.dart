import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nectar_app/utils/font_family.dart';
import 'package:nectar_app/utils/images_path.dart';
import 'package:nectar_app/utils/screens_path.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  nextPage() {
    Timer(
      const Duration(seconds: 3),
      () =>
          Navigator.pushReplacementNamed(context, ScreensPath.onbordingScreen),
    );
  }

  @override
  void initState() {
    super.initState();
    nextPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: Color(0xff53B175),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 60,
              child: Image.asset(ImagesPath.carotWhite),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.nectar,
                      style: const TextStyle(
                        fontSize: 55,
                        height: 1,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context)!.onlineGroceries,
                      style: const TextStyle(
                        height: 1,
                        fontFamily: FontFamily.medium,
                        letterSpacing: 3.9,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
