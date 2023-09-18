// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nectar_app/helpers/auth_helpers.dart';
import 'package:nectar_app/helpers/firestore_helpers.dart';
import 'package:nectar_app/main.dart';
import 'package:nectar_app/models/globals/globals.dart';
import 'package:nectar_app/utils/screens_path.dart';
import 'package:nectar_app/utils/users_info.dart';
import 'package:nectar_app/views/components/common_expansion_tile.dart';
import 'package:nectar_app/views/components/common_small_body_text.dart';
import 'package:shimmer/shimmer.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String userId = "";

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
      body: Padding(
        padding: EdgeInsets.only(top: h * 0.09),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: w * 0.04, right: w * 0.04),
              child: FutureBuilder(
                future:
                    FirestoreHelper.firestoreHelper.getUserData(uid: userId),
                builder: (context, snapShot) {
                  if (snapShot.hasError) {
                    return Text("${snapShot.error}");
                  } else if (snapShot.hasData) {
                    QuerySnapshot<Map<String, dynamic>>? data = snapShot.data;

                    List<QueryDocumentSnapshot<Map<String, dynamic>>> allDocs =
                        data!.docs;

                    Map<String, dynamic> userData = allDocs[0].data();

                    return Row(
                      children: [
                        Expanded(
                          child: CircleAvatar(
                            radius: 32,
                            backgroundColor: Colors.grey.shade300,
                            backgroundImage: (userData['photo'] == "")
                                ? const NetworkImage(
                                    "https://www.pngitem.com/pimgs/m/130-1300253_female-user-icon-png-download-user-image-color.png")
                                : NetworkImage("${allDocs[0].data()['photo']}"),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Padding(
                            padding: EdgeInsets.only(left: w * 0.03),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${userData['displayName']}",
                                  style:
                                      const TextStyle(fontSize: 20, height: 1),
                                ),
                                CommonSmallBodyText(
                                  text: "${userData['email']}",
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Row(
                      children: [
                        const Expanded(
                          child: CircleAvatar(
                            radius: 32,
                            backgroundColor: Colors.amber,
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Padding(
                            padding: EdgeInsets.only(left: w * 0.03),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: h * 0.03,
                                  width: w * 0.5,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: h * 0.01),
                                  child: Container(
                                    height: h * 0.02,
                                    width: w * 0.6,
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: h * 0.02),
              child: const Divider(),
            ),
            const CommonExpansionTile(
              title: "Orders",
              icon: Icon(Icons.shopping_bag_outlined),
            ),
            const CommonExpansionTile(
              title: "My Details",
              icon: Icon(Icons.badge_outlined),
            ),
            const CommonExpansionTile(
              title: "Delivery Address",
              icon: Icon(Icons.location_on_outlined),
            ),
            const CommonExpansionTile(
              title: "Payment Methods",
              icon: Icon(Icons.credit_card),
            ),
            const CommonExpansionTile(
              title: "Promo Code",
              icon: Icon(Icons.local_activity_outlined),
            ),
            const CommonExpansionTile(
              title: "Notifications",
              icon: Icon(Icons.notifications_on_outlined),
            ),
            const CommonExpansionTile(
              title: "Help",
              icon: Icon(Icons.help_outline),
            ),
            const CommonExpansionTile(
              title: "About",
              icon: Icon(Icons.error_outline),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(left: w * 0.08),
        child: GestureDetector(
          onTap: () async {
            FirebaseAuthHelper.firebaseAuthHelper.logOut();

            await sharedPreferences!.setBool(UsersInfo.userLogin, false);
            await sharedPreferences!.setString(UsersInfo.userId, '');
            Navigator.pushNamedAndRemoveUntil(
                context, ScreensPath.onbordingScreen, (route) => false);
          },
          child: Container(
            height: h * 0.07,
            width: w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              children: [
                Positioned(
                  left: w * 0.06,
                  top: h * 0.021,
                  child: Icon(
                    Icons.logout,
                    color: Globals.greenColor,
                  ),
                ),
                Center(
                  child: Text(
                    "Log Out",
                    style: TextStyle(
                      fontSize: 17,
                      color: Globals.greenColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
