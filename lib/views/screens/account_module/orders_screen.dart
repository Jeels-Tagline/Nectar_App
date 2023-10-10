import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nectar_app/helpers/firestore_helpers.dart';
import 'package:nectar_app/models/globals/globals.dart';
import 'package:nectar_app/utils/screens_path.dart';
import 'package:nectar_app/utils/user_data.dart';
import 'package:nectar_app/views/components/common_body_text.dart';
import 'package:nectar_app/views/components/common_headline_text.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  // String userId = "";

  // getUserId() async {
  //   userId = sharedPreferences!.getString(UsersInfo.userId) ?? '';

  //   setState(() {});
  // }

  @override
  void initState() {
    super.initState();
    // getUserId();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: CommonHeadlineText(
          title: AppLocalizations.of(context)!.myOrders,
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const Divider(),
            FutureBuilder(
              future: FirestoreHelper.firestoreHelper
                  .getOrdersData(uid: UserData.uid),
              builder: (context, snapShot) {
                if (snapShot.hasData) {
                  QuerySnapshot<Map<String, dynamic>>? userData = snapShot.data;

                  List<QueryDocumentSnapshot<Map<String, dynamic>>> allDocs =
                      userData!.docs;

                  if (allDocs.isEmpty) {
                    return Padding(
                      padding: EdgeInsets.only(top: h * 0.2),
                      child: Column(
                        children: [
                          Icon(
                            Icons.card_travel,
                            size: 200,
                            color: Globals.greenColor,
                          ),
                          Text(
                            AppLocalizations.of(context)!.orderIsEmpty,
                            style: TextStyle(
                                color: Globals.greenColor, fontSize: 25),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Padding(
                      padding: EdgeInsets.only(left: w * 0.04, right: w * 0.04),
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: allDocs.length,
                        itemBuilder: (context, i) {
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Map<String, dynamic> particularOrder = {
                                    'userId': UserData.uid,
                                    'date': allDocs[i].data()['date'],
                                    'id': allDocs[i].data()['id'],
                                  };

                                  Navigator.pushNamed(context,
                                      ScreensPath.particularOrderScreen,
                                      arguments: particularOrder);
                                },
                                child: SizedBox(
                                  height: h * 0.1,
                                  width: w,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Center(
                                          child: Text(
                                            "${i + 1}",
                                            style:
                                                const TextStyle(fontSize: 20),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 5,
                                        child: Padding(
                                          padding:
                                              EdgeInsets.only(left: w * 0.02),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "${allDocs[i].data()['date']}",
                                                    style: const TextStyle(
                                                      fontSize: 17,
                                                    ),
                                                  ),
                                                  CommonBodyText(
                                                    text:
                                                        "${allDocs[i].data()['items']} Items",
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                "\$ ${allDocs[i].data()['total_price']}",
                                                style: const TextStyle(
                                                  fontSize: 17,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Divider(),
                            ],
                          );
                        },
                      ),
                    );
                  }
                }

                return Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Padding(
                    padding: EdgeInsets.only(left: w * 0.04, right: w * 0.04),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: 4,
                      itemBuilder: (context, i) {
                        return Column(
                          children: [
                            SizedBox(
                              height: h * 0.1,
                              width: w,
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: w * 0.02),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: h * 0.025,
                                                width: w * 0.5,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: Colors.red,
                                                ),
                                              ),
                                              SizedBox(
                                                height: h * 0.01,
                                              ),
                                              Container(
                                                height: h * 0.02,
                                                width: w * 0.4,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            height: h * 0.025,
                                            width: w * 0.1,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(),
                          ],
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
