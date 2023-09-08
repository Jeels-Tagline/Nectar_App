// ignore_for_file: use_build_context_synchronously


import 'package:flutter/material.dart';
import 'package:nectar_app/helpers/auth_helpers.dart';
import 'package:nectar_app/models/globals/globals.dart';
import 'package:nectar_app/views/components/common_action_button.dart';
import 'package:nectar_app/views/components/common_auth_background.dart';
import 'package:nectar_app/views/components/common_small_body_text.dart';
import 'package:nectar_app/views/components/common_textfield.dart';
import 'package:nectar_app/views/components/common_title_text.dart';
import 'package:nectar_app/views/screens/signup_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  bool loggedIn = false;

  logIn({required String userId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    loggedIn = true;
    await prefs.setBool('isLoggedIn', loggedIn);
    await prefs.setString('isUserID', userId);
    Navigator.pushNamedAndRemoveUntil(
      context,
      'location_screen',
      (route) => false,
    );
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
                          "assets/logos/carot_orange.png",
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
                                .signIn(
                                    email: emailController.text,
                                    password: passwordController.text);

                            if (data['user'] != null) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context)
                                ..clearSnackBars()
                                ..showSnackBar(
                                  const SnackBar(
                                    content: Text("Signin Successfully...."),
                                    backgroundColor: Colors.green,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );

                              

                              logIn(userId: data['user'].uid);
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
                                    content: Text("Signin Faild....."),
                                    backgroundColor: Colors.red,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                            }
                          } else {
                            ScaffoldMessenger.of(context)
                              ..clearSnackBars()
                              ..showSnackBar(
                                const SnackBar(
                                  content: Text("Something went wrong...."),
                                  backgroundColor: Colors.red,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
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
                            // Navigator.pushReplacementNamed(
                            //     context, 'signup_screen');

                            Navigator.pushReplacement(
                              context,
                              PageTransition(
                                type: PageTransitionType.fade,
                                child: const SignupScreen(),
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
                                    fontFamily: 'Gilroy-Bold',
                                  ),
                                ),
                                TextSpan(
                                  text: "  Sign Up",
                                  style: TextStyle(
                                    color: Globals.greenColor,
                                    fontFamily: 'Gilroy-Bold',
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
