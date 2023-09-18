// ignore_for_file: use_build_context_synchronously, prefer_typing_uninitialized_variables, unused_local_variable

import 'package:flutter/material.dart';
import 'package:nectar_app/helpers/auth_helpers.dart';
import 'package:nectar_app/helpers/firestore_helpers.dart';
import 'package:nectar_app/main.dart';
import 'package:nectar_app/models/globals/globals.dart';
import 'package:nectar_app/utils/font_family.dart';
import 'package:nectar_app/utils/images_path.dart';
import 'package:nectar_app/utils/screens_path.dart';
import 'package:nectar_app/utils/users_info.dart';
import 'package:nectar_app/views/components/common_action_button.dart';
import 'package:nectar_app/views/components/common_auth_background.dart';
import 'package:nectar_app/views/components/common_show_dialog.dart';
import 'package:nectar_app/views/components/common_small_body_text.dart';
import 'package:nectar_app/views/components/common_scaffold_messenger.dart';
import 'package:nectar_app/views/components/common_textfield.dart';
import 'package:nectar_app/views/components/common_title_text.dart';
import 'package:nectar_app/views/screens/signup_screen.dart';
import 'package:page_transition/page_transition.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool loggedIn = false;
  var userLocation;

  logIn({required String userId, required bool isLocation}) async {
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

  void checkUserLocation({required String uid}) async {
    var data = await FirestoreHelper.firestoreHelper.getUserData(uid: uid);
    userLocation = data.docs;
    userLocation = userLocation[0].data()['location'];
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool passwordShow = false;
  bool emailVerify = false;

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          const CommonAuthBackground(),
          Padding(
            padding:
                EdgeInsets.only(top: h * 0.04, left: w * 0.06, right: w * 0.06),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: h * 0.27,
                      width: w,
                      child: const Image(
                        image: AssetImage(
                          ImagesPath.carotOrange,
                        ),
                      ),
                    ),
                    const CommonTitleText(title: "Sign In"),
                    Padding(
                      padding: EdgeInsets.only(top: h * 0.01),
                      child: CommonSmallBodyText(
                        text: "Enter your email and password",
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: h * 0.04),
                      child: CommonTextFormField(
                        controller: emailController,
                        textType: TextInputType.emailAddress,
                        textAction: TextInputAction.next,
                        labelText: "Email",
                        onChange: (val) {
                          if (val!.contains('@') && val.contains('.com')) {
                            setState(() {
                              emailVerify = true;
                            });
                          } else {
                            setState(() {
                              emailVerify = false;
                            });
                          }

                          return null;
                        },
                        suffixIcon: (emailVerify)
                            ? const Icon(
                                Icons.done,
                                color: Colors.green,
                              )
                            : const Icon(
                                Icons.close_rounded,
                                color: Colors.red,
                              ),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Enter your email...";
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: h * 0.01),
                      child: CommonTextFormField(
                        controller: passwordController,
                        textAction: TextInputAction.done,
                        suffix: IconButton(
                          onPressed: () {
                            setState(() {
                              passwordShow = !passwordShow;
                            });
                          },
                          icon: (passwordShow)
                              ? SizedBox(
                                  height: h * 0.020,
                                  child: const Icon(Icons.visibility_off),
                                )
                              : SizedBox(
                                  height: h * 0.010,
                                  child: const Icon(Icons.visibility),
                                ),
                        ),
                        labelText: "Password",
                        secureText: (passwordShow) ? false : true,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Enter your Password...";
                          } else if (val.length < 6) {
                            return "Enter Minimum 6 character password";
                          }
                          return null;
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(top: h * 0.02),
                        child: const CommonSmallBodyText(
                            text: "Forgot passwor?", color: Colors.black),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: h * 0.05),
                      child: GestureDetector(
                        onTap: () async {
                          if (formKey.currentState!.validate() && emailVerify) {
                            formKey.currentState!.save();
                             CommonShowDialog.show(context: context);

                            Map<String, dynamic> data = await FirebaseAuthHelper
                                .firebaseAuthHelper
                                .signIn(
                                    email: emailController.text,
                                    password: passwordController.text);

                            if (data['user'] != null) {
                               CommonShowDialog.close(context: context);

                              bool isLocation = false;
                              checkUserLocation(uid: data['user'].uid);
                              if (userLocation != "") {
                                isLocation = true;
                              }

                              logIn(
                                  userId: data['user'].uid,
                                  isLocation: isLocation);

                              CommonScaffoldMessenger.success(
                                  context: context,
                                  message: "Signin Successfully....");
                            } else if (data['msg'] != null) {
                              CommonScaffoldMessenger.failed(
                                  context: context, message: data['msg']);
                            } else {
                              CommonShowDialog.close(context: context);

                              CommonScaffoldMessenger.failed(
                                  context: context,
                                  message: "Signin Faild.....");
                            }
                          } else {
                            CommonScaffoldMessenger.failed(
                                context: context,
                                message: "Something went wrong....");
                          }
                        },
                        child: const CommonActionButton(name: "Sign In"),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: h * 0.02),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              PageTransition(
                                type: PageTransitionType.fade,
                                child: const SignUpScreen(),
                              ),
                            );
                          },
                          child: RichText(
                            text: TextSpan(
                              children: [
                                const TextSpan(
                                  text: "Don't have an account?",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: FontFamily.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: "  Sign Up",
                                  style: TextStyle(
                                    color: Globals.greenColor,
                                    fontFamily: FontFamily.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
