import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nectar_app/helpers/firestore_helpers.dart';
import 'package:nectar_app/models/globals/globals.dart';
import 'package:nectar_app/utils/screens_path.dart';
import 'package:nectar_app/utils/user_data.dart';
import 'package:nectar_app/views/components/common_body_text.dart';
import 'package:nectar_app/views/components/common_headline_text.dart';
import 'package:shimmer/shimmer.dart';

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
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: h * 0.07, bottom: h * 0.02),
              child:
                  const Center(child: CommonHeadlineText(title: "My Orders")),
            ),
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
                            Icons.favorite_border,
                            size: 200,
                            color: Globals.greenColor,
                          ),
                          Text(
                            "Order is empty",
                            style: TextStyle(
                                color: Globals.greenColor, fontSize: 25),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Transform.translate(
                      offset: Offset(0, -h * 0.04),
                      child: Padding(
                        padding:
                            EdgeInsets.only(left: w * 0.04, right: w * 0.04),
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
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
                      ),
                    );
                  }
                }

                return Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Transform.translate(
                    offset: Offset(0, -h * 0.04),
                    child: Padding(
                      padding: EdgeInsets.only(left: w * 0.04, right: w * 0.04),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: 4,
                        itemBuilder: (context, i) {
                          return Column(
                            children: [
                              SizedBox(
                                height: h * 0.14,
                                width: w,
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child: Padding(
                                        padding:
                                            EdgeInsets.only(left: w * 0.02),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  height: h * 0.025,
                                                  width: w * 0.5,
                                                  decoration: BoxDecoration(
                                                    color: Colors.red,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            7),
                                                  ),
                                                ),
                                                Transform.translate(
                                                  offset: Offset(w * 0.03, 0),
                                                  child: IconButton(
                                                    onPressed: () {},
                                                    icon: const Icon(
                                                      Icons.close,
                                                      size: 27,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Container(
                                              height: h * 0.015,
                                              width: w * 0.4,
                                              decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                            ),
                                            SizedBox(
                                              height: h * 0.01,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Container(
                                                      height: h * 0.045,
                                                      width: w * 0.095,
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors.grey,
                                                            width: 0.7),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                      ),
                                                      child: const Icon(
                                                        Icons.remove_outlined,
                                                      ),
                                                    ),
                                                    Container(
                                                      height: h * 0.02,
                                                      width: w * 0.08,
                                                      margin:
                                                          const EdgeInsets.all(
                                                              5),
                                                      decoration: BoxDecoration(
                                                          color: Colors.red,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5)),
                                                    ),
                                                    Container(
                                                      height: h * 0.045,
                                                      width: w * 0.095,
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors.grey,
                                                            width: 0.7),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                      ),
                                                      child: Icon(
                                                        Icons.add,
                                                        color:
                                                            Globals.greenColor,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  height: h * 0.025,
                                                  width: w * 0.2,
                                                  decoration: BoxDecoration(
                                                    color: Colors.red,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            7),
                                                  ),
                                                ),
                                              ],
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
