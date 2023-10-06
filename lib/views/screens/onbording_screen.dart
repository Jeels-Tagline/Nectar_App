// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:nectar_app/main.dart';
import 'package:nectar_app/utils/font_family.dart';
import 'package:nectar_app/utils/images_path.dart';
import 'package:nectar_app/utils/screens_path.dart';
import 'package:nectar_app/utils/users_info.dart';
import 'package:nectar_app/views/components/common_action_button.dart';
import 'package:nectar_app/views/components/common_small_body_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OnBordingScreen extends StatefulWidget {
  const OnBordingScreen({super.key});

  @override
  State<OnBordingScreen> createState() => _OnBordingScreenState();
}

class _OnBordingScreenState extends State<OnBordingScreen> {
  bool loggedIn = false;

  checkLogin() async {
    loggedIn = sharedPreferences!.getBool(UsersInfo.userLogin) ?? false;
    if (loggedIn == true) {
      Navigator.pushNamedAndRemoveUntil(
          context, ScreensPath.homeScreen, (route) => false);
    } else {
      Navigator.pushNamed(context, ScreensPath.logInScreen);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        height: h,
        width: w,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImagesPath.background),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          height: h,
          alignment: Alignment.bottomCenter,
          color: Colors.black.withOpacity(0.5),
          child: SizedBox(
            height: h / 2,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: h * 0.08,
                left: w * 0.045,
                right: w * 0.045,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: h * 0.07,
                    child: Image.asset(ImagesPath.carotWhite),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: h * 0.02),
                    child: Text(
                      AppLocalizations.of(context)!.welcome,
                      style: const TextStyle(
                        fontSize: 45,
                        fontFamily: FontFamily.medium,
                        height: 0.9,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: h * 0.01),
                    child: Text(
                      AppLocalizations.of(context)!.toOurStore,
                      style: const TextStyle(
                        fontSize: 45,
                        fontFamily: FontFamily.medium,
                        height: 0.2,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: h * 0.03),
                    child: CommonSmallBodyText(
                      text: AppLocalizations.of(context)!.onBordingDesc,
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: h * 0.03),
                    child: GestureDetector(
                      onTap: () {
                        checkLogin();
                      },
                      child: CommonActionButton(
                        name: AppLocalizations.of(context)!.getStarted,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
