// ignore_for_file: use_build_context_synchronously, prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nectar_app/helpers/firestore_helpers.dart';
import 'package:nectar_app/main.dart';
import 'package:nectar_app/models/globals/globals.dart';
import 'package:nectar_app/models/product_models.dart';
import 'package:nectar_app/utils/screens_path.dart';
import 'package:nectar_app/utils/users_info.dart';
import 'package:nectar_app/views/components/common_action_button.dart';
import 'package:nectar_app/views/components/common_body_text.dart';
import 'package:nectar_app/views/components/common_headline_text.dart';
import 'package:nectar_app/views/components/common_scaffold_messenger.dart';
import 'package:nectar_app/views/components/common_show_dialog.dart';
import 'package:shimmer/shimmer.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  String userId = "";
  bool dataEmpty = true;

  refreshUI() {
    Future.delayed(const Duration(seconds: 0), () {
      setState(() {});
    });
  }

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
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: h * 0.07, bottom: h * 0.02),
              child: const Center(
                  child: CommonHeadlineText(title: "My Favourite")),
            ),
            const Divider(),
            FutureBuilder(
              future:
                  FirestoreHelper.firestoreHelper.getFavouriteData(uid: userId),
              builder: (context, snapShot) {
                if (snapShot.hasData) {
                  QuerySnapshot<Map<String, dynamic>>? userData = snapShot.data;

                  List<QueryDocumentSnapshot<Map<String, dynamic>>> allDocs =
                      userData!.docs;
                  refreshUI();
                  if (allDocs.isEmpty) {
                    dataEmpty = true;
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
                            "Favourite is empty",
                            style: TextStyle(
                                color: Globals.greenColor, fontSize: 25),
                          ),
                        ],
                      ),
                    );
                  } else {
                    dataEmpty = false;
                    return Transform.translate(
                      offset: Offset(0, -h * 0.04),
                      child: Padding(
                        padding:
                            EdgeInsets.only(left: w * 0.04, right: w * 0.04, bottom: h * 0.08),
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: allDocs.length,
                          itemBuilder: (context, i) {
                            return Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    ProductModel productData = ProductModel(
                                      id: allDocs[i].data()['id'],
                                      name: allDocs[i].data()['name'],
                                      subTitle: allDocs[i].data()['subTitle'],
                                      price: allDocs[i].data()['price'],
                                      detail: allDocs[i].data()['detail'],
                                      nutrition: allDocs[i].data()['nutrition'],
                                      review: allDocs[i].data()['review'],
                                      type: allDocs[i].data()['type'],
                                      image1: allDocs[i].data()['image1'],
                                      image2: allDocs[i].data()['image2'],
                                      image3: allDocs[i].data()['image3'],
                                      quantity: allDocs[i].data()['quantity'],
                                      favourite: true,
                                    );
                                    Navigator.pushNamed(context,
                                        ScreensPath.productDetailScreen,
                                        arguments: productData);
                                  },
                                  child: SizedBox(
                                    height: h * 0.1,
                                    width: w,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Image.network(
                                            allDocs[i].data()['image1'],
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
                                                      "${allDocs[i].data()['name']}",
                                                      style: const TextStyle(
                                                        fontSize: 17,
                                                      ),
                                                    ),
                                                    CommonBodyText(
                                                      text:
                                                          "${allDocs[i].data()['subTitle']}",
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      "\$ ${allDocs[i].data()['price']}",
                                                      style: const TextStyle(
                                                        fontSize: 17,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: w * 0.01,
                                                    ),
                                                    const Icon(Icons
                                                        .arrow_forward_ios_rounded),
                                                  ],
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
                                height: h * 0.1,
                                width: w,
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(8),
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
                                                Container(
                                                  height: h * 0.025,
                                                  width: w * 0.5,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
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
                                                        BorderRadius.circular(
                                                            5),
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Container(
                                                  color: Colors.red,
                                                ),
                                                SizedBox(
                                                  width: w * 0.01,
                                                ),
                                                const Icon(Icons
                                                    .arrow_forward_ios_rounded),
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
      floatingActionButton: (dataEmpty)
          ? null
          : Padding(
              padding: EdgeInsets.only(left: w * 0.08),
              child: GestureDetector(
                onTap: () async {
                  CommonShowDialog.show(context: context);

                  var productData;
                  var data = await FirestoreHelper.firestoreHelper
                      .getFavouriteData(uid: userId);

                  productData = data.docs;

                  // Insert Records
                  for (int index = 0; index < productData.length; index++) {
                    Map<String, dynamic> data = {
                      'id': productData[index].data()['id'],
                      'name': productData[index].data()['name'],
                      'subTitle': productData[index].data()['subTitle'],
                      'price': productData[index].data()['price'],
                      'detail': productData[index].data()['detail'],
                      'nutrition': productData[index].data()['nutrition'],
                      'review': productData[index].data()['review'],
                      'type': productData[index].data()['type'],
                      'image1': productData[index].data()['image1'],
                      'image2': productData[index].data()['image2'],
                      'image3': productData[index].data()['image3'],
                      'quantity': productData[index].data()['quantity'] ?? 1,
                    };
                    await FirestoreHelper.firestoreHelper.insertCartData(
                      uid: userId,
                      productData: data,
                    );
                  }

                  CommonScaffoldMessenger.success(
                      context: context, message: 'All Items add to cart.....');

                  CommonShowDialog.close(context: context);
                },
                child: const CommonActionButton(
                  name: "Add all to Cart",
                ),
              ),
            ),
    );
  }
}
