// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:nectar_app/helpers/auth_helpers.dart';
import 'package:nectar_app/helpers/firestore_helpers.dart';
import 'package:nectar_app/models/globals/globals.dart';
import 'package:nectar_app/views/components/common_action_button.dart';
import 'package:nectar_app/views/components/common_auth_background.dart';
import 'package:nectar_app/views/components/common_small_body_text.dart';
import 'package:nectar_app/views/components/common_textfield.dart';
import 'package:nectar_app/views/components/common_title_text.dart';
import 'package:nectar_app/views/screens/signin_screen.dart';
import 'package:page_transition/page_transition.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool passwordShow = false;
  bool emailVerify = false;
  bool userVerify = false;
  bool isUser = false;

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
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
                    const CommonTitleText(title: "Sign Up"),
                    Padding(
                      padding: EdgeInsets.only(top: h * 0.01),
                      child: CommonSmallBodyText(
                        text: "Enter your credentials to continue",
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: h * 0.04),
                      child: CommonTextFormField(
                        controller: userNameController,
                        onChange: (val) {
                          if (val!.contains(' ') || val.length <= 6) {
                            setState(() {
                              userVerify = false;
                            });
                          } else {
                            setState(() {
                              userVerify = true;
                            });
                          }

                          return null;
                        },
                        suffixIcon: (userVerify)
                            ? const Icon(
                                Icons.done,
                                color: Colors.green,
                              )
                            : const Icon(
                                Icons.close_rounded,
                                color: Colors.red,
                              ),
                        textAction: TextInputAction.next,
                        labelText: "Username",
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Enter your Username...";
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: h * 0.01),
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
                              ? const Icon(Icons.visibility_off)
                              : const Icon(Icons.visibility),
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
                    Padding(
                      padding: EdgeInsets.only(top: h * 0.02),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "By continuing you agree to our",
                              style: TextStyle(
                                color: Colors.grey.shade600,
                              ),
                            ),
                            TextSpan(
                              text: "  Terms of Service",
                              style: TextStyle(
                                color: Globals.greenColor,
                              ),
                            ),
                            TextSpan(
                              text: "  and",
                              style: TextStyle(
                                color: Colors.grey.shade600,
                              ),
                            ),
                            TextSpan(
                              text: "  Privacy Policy",
                              style: TextStyle(
                                color: Globals.greenColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: h * 0.05),
                      child: GestureDetector(
                        onTap: () async {
                          if (formKey.currentState!.validate() &&
                              userVerify &&
                              emailVerify) {
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
                                .signUp(
                                    email: emailController.text,
                                    password: passwordController.text);

                            if (data['user'] != null) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context)
                                ..clearSnackBars()
                                ..showSnackBar(
                                  const SnackBar(
                                    content: Text("Signup Successfully...."),
                                    backgroundColor: Colors.green,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );

                              Map<String, dynamic> userdata = {
                                'uid': data['user'].uid,
                                'email': data['user'].email,
                                'phoneNumber': "",
                                'displayName': userNameController.text,
                                'location': "",
                                'cart': [],
                                'favourite': [],
                                'photo': "",
                              };

                              await FirestoreHelper.firestoreHelper
                                  .insertUsers(data: userdata);

                              Navigator.pushReplacementNamed(
                                  context, 'signin_screen');
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
                                    content: Text("Signup Faild....."),
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
                        child: const CommonActionButton(name: "Sign Up"),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: h * 0.02),
                        child: GestureDetector(
                          onTap: () {
                            // Navigator.pushReplacementNamed(
                            //   context,
                            //   'signin_screen',
                            // );

                            Navigator.pushReplacement(
                              context,
                              PageTransition(
                                type: PageTransitionType.fade,
                                child: const SigninScreen(),
                              ),
                            );
                          },
                          child: RichText(
                            text: TextSpan(
                              children: [
                                const TextSpan(
                                  text: "Already have an account?",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Gilroy-Bold',
                                  ),
                                ),
                                TextSpan(
                                  text: "  Sign In",
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
