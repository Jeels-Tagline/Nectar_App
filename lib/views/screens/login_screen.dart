// ignore_for_file: use_build_context_synchronously, unused_local_variable, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:nectar_app/helpers/auth_helpers.dart';
import 'package:nectar_app/helpers/firestore_helpers.dart';
import 'package:nectar_app/main.dart';
import 'package:nectar_app/utils/font_family.dart';
import 'package:nectar_app/utils/images_path.dart';
import 'package:nectar_app/utils/screens_path.dart';
import 'package:nectar_app/utils/users_info.dart';
import 'package:nectar_app/views/components/common_auth_background.dart';
import 'package:nectar_app/views/components/common_logo_button.dart';
import 'package:nectar_app/views/components/common_scaffold_messenger.dart';
import 'package:nectar_app/views/components/common_show_dialog.dart';
import 'package:nectar_app/views/components/common_title_text.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool loggedIn = false;
  String? location;
  var userData;

  Future logIn({required String userId, required bool isLocation}) async {
    loggedIn = true;
    await sharedPreferences!.setBool(UsersInfo.userLogin, loggedIn);
    await sharedPreferences!.setString(UsersInfo.userId, userId);

    (isLocation)
        ? Navigator.pushNamedAndRemoveUntil(
            context, ScreensPath.homeScreen, (route) => false)
        : Navigator.pushNamedAndRemoveUntil(
            context,
            ScreensPath.locationScreen,
            (route) => false,
          );
  }

  void dataCheck() async {
    var data = await FirestoreHelper.firestoreHelper.fetchUsers();
    userData = data.docs;
  }

  @override
  void initState() {
    super.initState();
    dataCheck();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          const CommonAuthBackground(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Image.asset(
                  ImagesPath.food,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CommonTitleText(title: "Get your groceries"),
                      const Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: CommonTitleText(title: "with nectar"),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: h * 0.03),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, ScreensPath.numberScreen);
                              },
                              child: Container(
                                height: h * 0.07,
                                width: w * 0.43,
                                decoration: BoxDecoration(
                                  color: const Color(0xff53B175),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: w * 0.04, right: w * 0.05),
                                      child: const Icon(
                                        Icons.phone,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const Center(
                                      child: Text(
                                        "Phone",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, ScreensPath.signInScreen);
                              },
                              child: Container(
                                height: h * 0.07,
                                width: w * 0.43,
                                decoration: BoxDecoration(
                                  color: const Color(0xff53B175),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: w * 0.04, right: w * 0.05),
                                      child: const Icon(
                                        Icons.email,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const Center(
                                      child: Text(
                                        "Email",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: h * 0.03),
                        child: Center(
                          child: Text(
                            "Or connect with social media",
                            style: TextStyle(
                              height: 1.8,
                              fontFamily: FontFamily.medium,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: h * 0.03),
                        child: GestureDetector(
                          onTap: () async {
                            CommonShowDialog.show(
                                context: context, dismissible: true);

                            Map<String, dynamic> data = await FirebaseAuthHelper
                                .firebaseAuthHelper
                                .signInWithGoogle();

                            if (data['user'] != null) {
                              CommonShowDialog.close(context: context);

                              bool isUser = false;
                              bool isLocation = false;

                              for (int i = 0; i < userData.length; i++) {
                                if (userData[i].data()['uid'] ==
                                    data['user'].uid) {
                                  isUser = true;
                                  if (userData[i].data()['location'] != "") {
                                    isLocation = true;
                                  }
                                }
                              }

                              if (isUser == false) {
                                Map<String, dynamic> userdata = {
                                  'uid': data['user'].uid,
                                  'email': data['user'].email,
                                  'phoneNumber': "",
                                  'displayName': data['user'].displayName,
                                  'location': "",
                                  'photo': "",
                                  'totalPrice': 0.00,
                                };

                                await FirestoreHelper.firestoreHelper
                                    .insertUsers(data: userdata);
                              }

                              await logIn(
                                  userId: data['user'].uid,
                                  isLocation: isLocation);
                              CommonScaffoldMessenger.success(
                                message: 'Loggin Successfully......',
                                context: context,
                              );
                            } else if (data['msg'] != null) {
                              CommonShowDialog.close(context: context);
                              CommonScaffoldMessenger.failed(
                                  context: context, message: '${data['msg']}');
                            } else if (data['close'] == 'close') {
                              CommonShowDialog.close(context: context);
                            } else {
                              CommonShowDialog.close(context: context);

                              CommonScaffoldMessenger.failed(
                                  context: context,
                                  message: 'Loggin Failed.....');
                            }
                          },
                          child: CommonLogoButton(
                            logo: ImagesPath.google,
                            name: "Continue with Google",
                            color: Colors.red.shade400,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: h * 0.02),
                        child: const CommonLogoButton(
                          logo: ImagesPath.facebook,
                          name: "Continue with Facebook",
                          color: Color(0xff4A66Ac),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
