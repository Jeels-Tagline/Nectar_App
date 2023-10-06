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
import 'package:nectar_app/views/components/common_check_user_connection.dart';
import 'package:nectar_app/views/components/common_logo_button.dart';
import 'package:nectar_app/views/components/common_scaffold_messenger.dart';
import 'package:nectar_app/views/components/common_show_dialog.dart';
import 'package:nectar_app/views/components/common_title_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool loggedIn = false;

  var userData;

  Future logIn({
    required bool isLocation,
    required String uid,
    // required String city,
    // required String displayName,
    // required String email,
    // required String location,
    // required String phoneNumber,
    // required String photo,
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
                      CommonTitleText(
                        title: AppLocalizations.of(context)!.getYourGroceries,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: CommonTitleText(
                            title: AppLocalizations.of(context)!.withNectar),
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
                                    Center(
                                      child: Text(
                                        AppLocalizations.of(context)!.phone,
                                        style: const TextStyle(
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
                                    Center(
                                      child: Text(
                                        AppLocalizations.of(context)!.email,
                                        style: const TextStyle(
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
                            AppLocalizations.of(context)!.orConnectLogin,
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
                            bool connection = await CommonCheckUserConnection
                                .checkUserConnection();

                            if (connection) {
                              CommonShowDialog.show(
                                  context: context, dismissible: true);

                              Map<String, dynamic> data =
                                  await FirebaseAuthHelper.firebaseAuthHelper
                                      .signInWithGoogle();

                              if (data['user'] != null) {
                                CommonShowDialog.close(context: context);
                                bool isUser = false;
                                bool isLocation = false;
                                // String? city;
                                // String? location;

                                for (int i = 0; i < userData.length; i++) {
                                  if (userData[i].data()['uid'] ==
                                      data['user'].uid) {
                                    isUser = true;
                                    if (userData[i].data()['location'] != "") {
                                      // city = userData[i].data()['city'];
                                      // location = userData[i].data()['location'];
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
                                  isLocation: isLocation,
                                  uid: data['user'].uid,
                                  // city: city!,
                                  // location: location!,
                                  // displayName: data['user'].displayName,
                                  // email: data['user'].email,
                                  // phoneNumber: data['user'].phoneNumber ?? '',
                                  // photo:
                                );

                                CommonScaffoldMessenger.success(
                                  message: AppLocalizations.of(context)!
                                      .loginSuccesfully,
                                  context: context,
                                );
                              } else if (data['msg'] != null) {
                                CommonShowDialog.close(context: context);
                                CommonScaffoldMessenger.failed(
                                    context: context,
                                    message: '${data['msg']}');
                              } else if (data['close'] == 'close') {
                                CommonShowDialog.close(context: context);
                              } else {
                                CommonShowDialog.close(context: context);

                                CommonScaffoldMessenger.failed(
                                    context: context,
                                    message: AppLocalizations.of(context)!
                                        .loginFailed);
                              }
                            } else {
                              CommonScaffoldMessenger.failed(
                                context: context,
                                message: AppLocalizations.of(context)!
                                    .checkInternetConnection,
                              );
                            }
                          },
                          child: CommonLogoButton(
                            logo: ImagesPath.google,
                            name: AppLocalizations.of(context)!
                                .continueWithGoogle,
                            color: Colors.red.shade400,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: h * 0.02),
                        child: CommonLogoButton(
                          logo: ImagesPath.facebook,
                          name: AppLocalizations.of(context)!
                              .continueWithFacebook,
                          color: const Color(0xff4A66Ac),
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
