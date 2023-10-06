import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nectar_app/helpers/firestore_helpers.dart';
import 'package:nectar_app/views/components/common_body_text.dart';
import 'package:nectar_app/views/components/common_headline_text.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ParticularOrderScreen extends StatefulWidget {
  const ParticularOrderScreen({super.key});

  @override
  State<ParticularOrderScreen> createState() => _ParticularOrderScreenState();
}

class _ParticularOrderScreenState extends State<ParticularOrderScreen> {
  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings.arguments as Map;
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: h * 0.07, bottom: h * 0.02),
              child: Center(
                  child: CommonHeadlineText(
                title: AppLocalizations.of(context)!.myOrders,
              )),
            ),
            const Divider(),
            FutureBuilder(
              future: FirestoreHelper.firestoreHelper.getProductOfOrderData(
                uid: data['userId'],
                orderId: data['id'],
                date: data['date'],
              ),
              builder: (context, snapShot) {
                if (snapShot.hasData) {
                  QuerySnapshot<Map<String, dynamic>>? userData = snapShot.data;

                  List<QueryDocumentSnapshot<Map<String, dynamic>>> allDocs =
                      userData!.docs;

                  return Transform.translate(
                    offset: Offset(0, -h * 0.04),
                    child: Padding(
                      padding: EdgeInsets.only(left: w * 0.04, right: w * 0.04),
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: allDocs.length,
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
                                      child: Image.network(
                                        allDocs[i].data()['image'],
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
                                                  "${allDocs[i].data()['name']}",
                                                  style: const TextStyle(
                                                    fontSize: 17,
                                                  ),
                                                ),
                                                CommonBodyText(
                                                  text:
                                                      "Quantity : ${allDocs[i].data()['quantity']}",
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
                              const Divider(),
                            ],
                          );
                        },
                      ),
                    ),
                  );
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
    );
  }
}
