// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:nectar_app/helpers/auth_helpers.dart';
import 'package:nectar_app/helpers/firestore_helpers.dart';
import 'package:nectar_app/models/globals/globals.dart';
import 'package:nectar_app/utils/font_family.dart';
import 'package:nectar_app/utils/images_path.dart';
import 'package:nectar_app/utils/screens_path.dart';
import 'package:nectar_app/views/components/common_action_button.dart';
import 'package:nectar_app/views/components/common_auth_background.dart';
import 'package:nectar_app/views/components/common_show_dialog.dart';
import 'package:nectar_app/views/components/common_small_body_text.dart';
import 'package:nectar_app/views/components/common_scaffold_messenger.dart';
import 'package:nectar_app/views/components/common_textfield.dart';
import 'package:nectar_app/views/components/common_title_text.dart';
import 'package:nectar_app/views/screens/signin_screen.dart';
import 'package:page_transition/page_transition.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
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
                          ImagesPath.carotOrange,
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
                          if (val!.length <= 6) {
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
                            CommonShowDialog.show(context: context);

                            Map<String, dynamic> data = await FirebaseAuthHelper
                                .firebaseAuthHelper
                                .signUp(
                                    email: emailController.text,
                                    password: passwordController.text);

                            if (data['user'] != null) {
                              CommonScaffoldMessenger.success(
                                  context: context,
                                  message: "Signup Successfully....");

                              Map<String, dynamic> userdata = {
                                'uid': data['user'].uid,
                                'email': data['user'].email,
                                'phoneNumber': "",
                                'displayName': userNameController.text,
                                'location': "",
                                'photo': "",
                                'totalPrice': 0.00,
                              };

                              await FirestoreHelper.firestoreHelper
                                  .insertUsers(data: userdata);

                              Navigator.pushReplacementNamed(
                                  context, ScreensPath.signInScreen);
                            } else if (data['msg'] != null) {
                              CommonShowDialog.close(context: context);
                              CommonScaffoldMessenger.failed(
                                  context: context, message: data['msg']);
                            } else {
                              CommonShowDialog.close(context: context);

                              CommonScaffoldMessenger.failed(
                                  context: context,
                                  message: "Signup Faild.....");
                            }
                          } else {
                            CommonScaffoldMessenger.failed(
                                context: context,
                                message: "Something went wrong....");
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
                            Navigator.pushReplacement(
                              context,
                              PageTransition(
                                type: PageTransitionType.fade,
                                child: const SignInScreen(),
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
                                    fontFamily: FontFamily.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: "  Sign In",
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
