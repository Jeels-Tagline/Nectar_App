// ignore_for_file: use_build_context_synchronously, await_only_futures, unused_local_variable, prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nectar_app/helpers/auth_helpers.dart';
import 'package:nectar_app/helpers/firestore_helpers.dart';
import 'package:nectar_app/main.dart';
import 'package:nectar_app/utils/font_family.dart';
import 'package:nectar_app/utils/screens_path.dart';
import 'package:nectar_app/utils/users_info.dart';
import 'package:nectar_app/views/components/common_auth_background.dart';
import 'package:nectar_app/views/components/common_body_text.dart';
import 'package:nectar_app/views/components/common_scaffold_messenger.dart';
import 'package:nectar_app/views/components/common_show_dialog.dart';
import 'package:nectar_app/views/components/common_title_text.dart';

class NumberVerificationScreen extends StatefulWidget {
  const NumberVerificationScreen({super.key});

  @override
  State<NumberVerificationScreen> createState() =>
      _NumberVerificationScreenState();
}

class _NumberVerificationScreenState extends State<NumberVerificationScreen> {
  bool loggedIn = false;

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

  TextEditingController otpController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final userData = ModalRoute.of(context)!.settings.arguments as Map;
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          const CommonAuthBackground(),
          Padding(
            padding: EdgeInsets.only(
              top: h * 0.07,
            ),
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
                  padding: EdgeInsets.only(
                    top: h * 0.09,
                    left: w * 0.045,
                    right: w * 0.045,
                  ),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CommonTitleText(
                          title: "Enter your 6-digit code",
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: h * 0.05),
                          child: const CommonBodyText(text: "Code"),
                        ),
                        TextFormField(
                          controller: otpController,
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Enter OTP";
                            } else {
                              if (val.length != 6) {
                                return "Enter Valid OTP";
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
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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
                    formKey.currentState!.save();

                    CommonShowDialog.show(context: context);

                    Map data = await FirebaseAuthHelper.firebaseAuthHelper
                        .verifyOTP(otp: otpController.text);

                    if (data['user'] != null) {
                      CommonShowDialog.close(context: context);

                      bool isUser = false;
                      bool isLocation = false;

                      for (int i = 0; i < allUsers.length; i++) {
                        if (allUsers[i].data()['uid'] == data['user'].uid) {
                          isUser = true;
                          if (allUsers[i].data()['location'] != null) {
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

                      logIn(userId: data['user'].uid, isLocation: isLocation);
                      CommonScaffoldMessenger.success(
                          context: context, message: "Login Successfully....");
                    } else if (data['msg'] != null) {
                      CommonShowDialog.close(context: context);
                      CommonScaffoldMessenger.failed(
                          context: context, message: data['msg']);
                    } else {
                      CommonShowDialog.close(context: context);
                      CommonScaffoldMessenger.failed(
                          context: context, message: "Logging Failed.....");
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
