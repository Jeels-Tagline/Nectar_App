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
import 'package:nectar_app/views/components/common_check_user_connection.dart';
import 'package:nectar_app/views/components/common_show_dialog.dart';
import 'package:nectar_app/views/components/common_small_body_text.dart';
import 'package:nectar_app/views/components/common_scaffold_messenger.dart';
import 'package:nectar_app/views/components/common_textfield.dart';
import 'package:nectar_app/views/components/common_title_text.dart';
import 'package:nectar_app/views/screens/auth_module/forgot_password_screen.dart';
import 'package:nectar_app/views/screens/auth_module/signup_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool loggedIn = false;
  var userLocation;
  // var usercity;

  logIn({
    required String uid,
    // required String city,
    // required String displayName,
    // required String email,
    // required String location,
    // required String phoneNumber,
    required bool isLocation,
  }) async {
    loggedIn = true;
    await sharedPreferences!.setBool(UsersInfo.userLogin, loggedIn);
    await sharedPreferences!.setString(UsersInfo.userId, uid);

    CommonShowDialog.show(context: context);

    await FirestoreHelper.firestoreHelper.dataStoreInHive();

    var data = await FirestoreHelper.firestoreHelper.getUserData(uid: uid);
    var userData = data.docs[0].data();

    await sharedPreferences!
        .setString(UsersInfo.userCity, userData['city'] ?? '');
    await sharedPreferences!
        .setString(UsersInfo.userDisplayName, userData['displayName']);
    await sharedPreferences!.setString(UsersInfo.userEmail, userData['email']);
    await sharedPreferences!
        .setString(UsersInfo.userLocation, userData['location'] ?? '');
    await sharedPreferences!
        .setString(UsersInfo.userPhoneNumber, userData['phoneNumber'] ?? '');
    await sharedPreferences!
        .setString(UsersInfo.userPhoto, userData['photo'] ?? '');

    CommonShowDialog.close(context: context);

    (isLocation)
        ? Navigator.pushNamedAndRemoveUntil(
            context, ScreensPath.bottomNavigationScreen, (route) => false)
        : Navigator.pushNamedAndRemoveUntil(
            context,
            ScreensPath.locationScreen,
            (route) => false,
          );
  }

  Future checkUserLocation({required String uid}) async {
    var data = await FirestoreHelper.firestoreHelper.getUserData(uid: uid);
    userLocation = data.docs;
    userLocation = userLocation[0].data()['location'];
    // usercity = data.docs;
    // usercity = userLocation[0].data()['city'];
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
      body: CommonAuthBackground(
        child: Padding(
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
                  CommonTitleText(
                    title: AppLocalizations.of(context)!.signIn,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: h * 0.01),
                    child: CommonSmallBodyText(
                      text: AppLocalizations.of(context)!
                          .enterYourEmailAndPassword,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: h * 0.04),
                    child: CommonTextFormField(
                      controller: emailController,
                      textType: TextInputType.emailAddress,
                      textAction: TextInputAction.next,
                      labelText: AppLocalizations.of(context)!.email,
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
                          return AppLocalizations.of(context)!.enterYourEmail;
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
                      labelText: AppLocalizations.of(context)!.password,
                      secureText: (passwordShow) ? false : true,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return AppLocalizations.of(context)!
                              .enterYourPassword;
                        } else if (val.length < 6) {
                          return AppLocalizations.of(context)!
                              .enterMinimum6CharacterPassword;
                        }
                        return null;
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(top: h * 0.02),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.fade,
                              child: const ForgotPasswordScreen(),
                            ),
                          );
                        },
                        child: CommonSmallBodyText(
                          text: AppLocalizations.of(context)!.forgotPassword,
                          color: Globals.greenColor,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: h * 0.05),
                    child: GestureDetector(
                      onTap: () async {
                        if (formKey.currentState!.validate() && emailVerify) {
                          bool connection = await CommonCheckUserConnection
                              .checkUserConnection();

                          if (connection) {
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
                              await checkUserLocation(uid: data['user'].uid);

                              // String? location;
                              // String? city;

                              if (userLocation != null &&
                                  userLocation.isNotEmpty) {
                                // location = userLocation;
                                // city = usercity;
                                isLocation = true;
                                setState(() {});
                              }

                              await logIn(
                                // city: city!,
                                // location: location!,
                                // displayName: data['user'].displayName,
                                // email: data['user'].displayName,
                                // phoneNumber: '',
                                isLocation: isLocation,
                                uid: data['user'].uid,
                              );

                              CommonScaffoldMessenger.success(
                                context: context,
                                message: AppLocalizations.of(context)!
                                    .loginSuccesfully,
                              );
                            } else if (data['msg'] != null) {
                              CommonShowDialog.close(context: context);
                              CommonScaffoldMessenger.failed(
                                  context: context, message: data['msg']);
                            } else {
                              CommonShowDialog.close(context: context);

                              CommonScaffoldMessenger.failed(
                                context: context,
                                message:
                                    AppLocalizations.of(context)!.loginFailed,
                              );
                            }
                          } else {
                            CommonScaffoldMessenger.failed(
                              context: context,
                              message: AppLocalizations.of(context)!
                                  .checkInternetConnection,
                            );
                          }
                        } else {
                          CommonScaffoldMessenger.failed(
                            context: context,
                            message:
                                AppLocalizations.of(context)!.somethingWrong,
                          );
                        }
                      },
                      child: CommonActionButton(
                        name: AppLocalizations.of(context)!.signIn,
                      ),
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
                              TextSpan(
                                text: AppLocalizations.of(context)!
                                    .dontHaveAnAccount,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontFamily: FontFamily.bold,
                                ),
                              ),
                              TextSpan(
                                text:
                                    "  ${AppLocalizations.of(context)!.signUp}",
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
                  const SizedBox(
                    height: 100,
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
