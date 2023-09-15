// ignore_for_file: use_build_context_synchronously, unused_local_variable, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:nectar_app/helpers/auth_helpers.dart';
import 'package:nectar_app/helpers/firestore_helpers.dart';
import 'package:nectar_app/main.dart';
import 'package:nectar_app/utils/font_family.dart';
import 'package:nectar_app/utils/screens_path.dart';
import 'package:nectar_app/views/components/common_auth_background.dart';
import 'package:nectar_app/views/components/common_logo_button.dart';
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

  logIn({required String userId, required bool isLocation}) async {
    loggedIn = true;
    await sharedPreferences!.setBool('isLoggedIn', loggedIn);
    await sharedPreferences!.setString('isUserID', userId);

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
      body:
          // FutureBuilder(
          //   future: FirestoreHelper.firestoreHelper.fetchUsers(),
          //   builder: (context, snapShot) {
          //     if (snapShot.hasError) {
          //       return Center(
          //         child: Text("Error : ${snapShot.error}"),
          //       );
          //     } else if (snapShot.hasData) {
          //       QuerySnapshot<Map<String, dynamic>>? data = snapShot.data;

          //       if (data == null) {
          //         return const Center(
          //           child: Text("No Any Data Available...."),
          //         );
          //       } else {
          //         List<QueryDocumentSnapshot<Map<String, dynamic>>> allUsers =
          //             data.docs;

          //         return

          Stack(
        children: [
          const CommonAuthBackground(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Image.asset(
                  "assets/images/food.jpeg",
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
                                Navigator.pushNamed(context, ScreensPath.numberScreen);
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
                                Navigator.pushNamed(context, ScreensPath.signInScreen);
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
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return const AlertDialog(
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Loading'),
                                      CircularProgressIndicator(),
                                    ],
                                  ),
                                );
                              },
                            );

                            Map<String, dynamic> data = await FirebaseAuthHelper
                                .firebaseAuthHelper
                                .googleLogin();

                            if (data['user'] != null) {
                              Navigator.pop(context);
                              bool isUser = false;
                              bool isLocation = false;

                              for (int i = 0; i < userData.length; i++) {
                                if (userData[i].data()['uid'] ==
                                    data['user'].uid) {
                                  isUser = true;
                                  if (userData[i].data()['location'] != null) {
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

                              logIn(
                                  userId: data['user'].uid,
                                  isLocation: isLocation);
                              ScaffoldMessenger.of(context)
                                ..clearSnackBars()
                                ..showSnackBar(
                                  const SnackBar(
                                    content: Text("Login Successfully...."),
                                    backgroundColor: Colors.green,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                            } else if (data['msg'] != null) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context)
                                ..clearSnackBars()
                                ..showSnackBar(
                                  SnackBar(
                                    content: Text("${data['msg']}"),
                                    backgroundColor: Colors.red,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                            } else {
                              Navigator.pop(context);

                              ScaffoldMessenger.of(context)
                                ..clearSnackBars()
                                ..showSnackBar(
                                  const SnackBar(
                                    content: Text("Loggin Faild....."),
                                    backgroundColor: Colors.red,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                            }
                          },
                          child: CommonLogoButton(
                            logo: "assets/logos/google.png",
                            name: "Continue with Google",
                            color: Colors.red.shade400,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: h * 0.02),
                        child: const CommonLogoButton(
                          logo: "assets/logos/facebook.png",
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
      //       }
      //     }
      //     return Container();
      //   },
      // ),
    );
  }
}
