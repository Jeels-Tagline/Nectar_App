// ignore_for_file: use_build_context_synchronously, await_only_futures, unused_local_variable, prefer_typing_uninitialized_variables

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nectar_app/helpers/auth_helpers.dart';
import 'package:nectar_app/helpers/firestore_helpers.dart';
import 'package:nectar_app/main.dart';
import 'package:nectar_app/models/globals/globals.dart';
import 'package:nectar_app/utils/font_family.dart';
import 'package:nectar_app/utils/screens_path.dart';
import 'package:nectar_app/utils/users_info.dart';
import 'package:nectar_app/views/components/common_auth_background.dart';
import 'package:nectar_app/views/components/common_body_text.dart';
import 'package:nectar_app/views/components/common_check_user_connection.dart';
import 'package:nectar_app/views/components/common_scaffold_messenger.dart';
import 'package:nectar_app/views/components/common_show_dialog.dart';
import 'package:nectar_app/views/components/common_title_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NumberVerificationScreen extends StatefulWidget {
  const NumberVerificationScreen({super.key});

  @override
  State<NumberVerificationScreen> createState() =>
      _NumberVerificationScreenState();
}

class _NumberVerificationScreenState extends State<NumberVerificationScreen> {
  bool loggedIn = false;

  int secResend = 60;
  bool enableResendButton = false;

  startTimer() {
    const oneSec = Duration(seconds: 1);

    Timer timer = Timer.periodic(oneSec, (timer) {
      if (secResend == 0) {
        setState(() {
          enableResendButton = true;
          timer.cancel();
        });
      } else {
        setState(() {
          secResend--;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

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
    await sharedPreferences!
        .setString(UsersInfo.userEmail, userData['email'] ?? '');
    await sharedPreferences!
        .setString(UsersInfo.userLocation, userData['location'] ?? '');
    await sharedPreferences!
        .setString(UsersInfo.userPhoneNumber, userData['phoneNumber']);
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

  TextEditingController otpController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final userData = ModalRoute.of(context)!.settings.arguments as Map;

    return Scaffold(
      body: CommonAuthBackground(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 65,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 80,
                    left: 16,
                    right: 16,
                  ),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonTitleText(
                          title:
                              AppLocalizations.of(context)!.enterYour6DigitCode,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 45),
                          child: CommonBodyText(
                            text: AppLocalizations.of(context)!.code,
                          ),
                        ),
                        TextFormField(
                          controller: otpController,
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return AppLocalizations.of(context)!.enterOtp;
                            } else {
                              if (val.length != 6) {
                                return AppLocalizations.of(context)!
                                    .enterValidOtp;
                              }
                            }
                            return null;
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          style: const TextStyle(
                            fontSize: 22,
                            fontFamily: FontFamily.medium,
                          ),
                          decoration: const InputDecoration(
                            counterText: "",
                            hintText: "------",
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 45),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (enableResendButton)
                                GestureDetector(
                                  onTap: () async {
                                    setState(() {
                                      secResend = 60;
                                      startTimer();
                                      enableResendButton = false;
                                    });
                                    await FirebaseAuthHelper.firebaseAuthHelper
                                        .phoneLogin(
                                            phoneNumber:
                                                userData['phoneNumber']);
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)!.reset,
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Globals.greenColor,
                                    ),
                                  ),
                                )
                              else
                                Text(
                                  '${AppLocalizations.of(context)!.resetOtpIn} 00:$secResend',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontFamily: FontFamily.medium,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 100,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FutureBuilder(
        future: FirestoreHelper.firestoreHelper.fetchUsers(),
        builder: (context, snapShot) {
          if (snapShot.hasError) {
            return Center(
              child: Text("Error : ${snapShot.error}"),
            );
          } else if (snapShot.hasData) {
            QuerySnapshot<Map<String, dynamic>>? data = snapShot.data;

            if (data == null) {
              return const Center(
                child: Text("No Any Data Available...."),
              );
            } else {
              List<QueryDocumentSnapshot<Map<String, dynamic>>> allUsers =
                  data.docs;

              return GestureDetector(
                onTap: () async {
                  if (formKey.currentState!.validate()) {
                    bool connection =
                        await CommonCheckUserConnection.checkUserConnection();

                    if (connection) {
                      formKey.currentState!.save();

                      CommonShowDialog.show(context: context);

                      Map data = await FirebaseAuthHelper.firebaseAuthHelper
                          .verifyOTP(otp: otpController.text);

                      if (data['user'] != null) {
                        CommonShowDialog.close(context: context);

                        bool isUser = false;
                        bool isLocation = false;
                        String? city;
                        String? location;

                        for (int i = 0; i < allUsers.length; i++) {
                          if (allUsers[i].data()['uid'] == data['user'].uid) {
                            isUser = true;
                            if (userData[i].data()['location'] != "") {
                              city = userData[i].data()['city'];
                              location = userData[i].data()['location'];
                              isLocation = true;
                            }
                          }
                        }

                        if (isUser == false) {
                          Map<String, dynamic> userdata = {
                            'uid': data['user'].uid,
                            'email': "",
                            'phoneNumber': userData['phoneNumber'],
                            'displayName': userData['userName'],
                            'location': "",
                            'photo': "",
                            'totalPrice': 0.00,
                          };

                          await FirestoreHelper.firestoreHelper
                              .insertUsers(data: userdata);
                        }

                        await logIn(
                          uid: data['user'].uid,
                          isLocation: isLocation,
                          // city: city!,
                          // location: location!,
                          // displayName: userData['userName'],
                          // email: '',
                          // phoneNumber: userData['phoneNumber'],
                        );

                        CommonScaffoldMessenger.success(
                          context: context,
                          message:
                              AppLocalizations.of(context)!.loginSuccesfully,
                        );
                      } else if (data['msg'] != null) {
                        CommonShowDialog.close(context: context);
                        CommonScaffoldMessenger.failed(
                            context: context, message: data['msg']);
                      } else {
                        CommonShowDialog.close(context: context);
                        CommonScaffoldMessenger.failed(
                          context: context,
                          message: AppLocalizations.of(context)!.loginFailed,
                        );
                      }
                    } else {
                      CommonScaffoldMessenger.failed(
                        context: context,
                        message: AppLocalizations.of(context)!
                            .checkInternetConnection,
                      );
                    }
                  }
                },
                child: const CircleAvatar(
                  radius: 30,
                  backgroundColor: Color(0xff53B175),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white,
                  ),
                ),
              );
            }
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
