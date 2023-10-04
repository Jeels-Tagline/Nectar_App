// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:nectar_app/helpers/firestore_helpers.dart';
import 'package:nectar_app/main.dart';
import 'package:nectar_app/utils/images_path.dart';
import 'package:nectar_app/utils/screens_path.dart';
import 'package:nectar_app/utils/users_info.dart';
import 'package:nectar_app/views/components/common_action_button.dart';
import 'package:nectar_app/views/components/common_auth_background.dart';
import 'package:nectar_app/views/components/common_body_text.dart';
import 'package:nectar_app/views/components/common_check_user_connection.dart';
import 'package:nectar_app/views/components/common_scaffold_messenger.dart';
import 'package:nectar_app/views/components/common_small_body_text.dart';
import 'package:nectar_app/views/components/common_title_text.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  String userId = "";
  Map userData = {};

  getUserId() async {
    userId = sharedPreferences!.getString(UsersInfo.userId) ?? '';

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getUserId();
  }

  @override
  Widget build(BuildContext context) {
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
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: h * 0.06,
                      left: w * 0.06,
                      right: w * 0.06,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: h / 2.3,
                          width: w,
                          child: Column(
                            children: [
                              SizedBox(
                                height: h * 0.18,
                                child: const Image(
                                  image: AssetImage(
                                    ImagesPath.location,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: h * 0.04),
                                child: const CommonTitleText(
                                    title: "Select Your Location"),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: h * 0.01),
                                child: CommonSmallBodyText(
                                  text:
                                      "Swithch on your location to stay in tune with what's happning in your area",
                                  color: Colors.grey.shade700,
                                  align: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const CommonBodyText(text: "Your Location"),
                        Padding(
                          padding: EdgeInsets.only(top: h * 0.01),
                          child: GestureDetector(
                            onTap: () async {
                              bool connection = await CommonCheckUserConnection
                                  .checkUserConnection();

                              if (connection) {
                                userData = await Navigator.pushNamed(
                                        context, ScreensPath.getLocationScreen)
                                    as Map;
                                setState(() {});
                              } else {
                                CommonScaffoldMessenger.failed(
                                    context: context,
                                    message: 'Check Internet Connection');
                              }
                            },
                            child: Card(
                              child: ListTile(
                                title: Text(
                                  userData['location'] ?? "Get Location",
                                  style: const TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                trailing: const Icon(Icons.location_on),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: h * 0.2),
                          child: GestureDetector(
                            onTap: () async {
                              bool connection = await CommonCheckUserConnection
                                  .checkUserConnection();

                              if (connection) {
                                if (userData['location'] != null) {
                                  await FirestoreHelper.firestoreHelper
                                      .updateAddress(
                                    uid: userId,
                                    location: userData['location'],
                                    city: userData['city'],
                                  );

                                  await sharedPreferences!.setString(
                                      UsersInfo.userLocation,
                                      userData['location']);
                                  await sharedPreferences!.setString(
                                      UsersInfo.userCity, userData['city']);

                                  Navigator.pushNamedAndRemoveUntil(context,
                                      ScreensPath.homeScreen, (route) => false);
                                } else {
                                  CommonScaffoldMessenger.failed(
                                      context: context,
                                      message: "Please select location.....");
                                }
                              } else {
                                CommonScaffoldMessenger.failed(
                                    context: context,
                                    message: 'Check Internet Connection');
                              }
                            },
                            child: const CommonActionButton(name: "Submit"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
