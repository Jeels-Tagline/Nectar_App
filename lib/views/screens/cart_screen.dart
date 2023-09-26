// ignore_for_file: use_build_context_synchronously, prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nectar_app/helpers/firestore_helpers.dart';
import 'package:nectar_app/main.dart';
import 'package:nectar_app/models/globals/globals.dart';
import 'package:nectar_app/models/product_models.dart';
import 'package:nectar_app/navigator.dart';
import 'package:nectar_app/utils/images_path.dart';
import 'package:nectar_app/utils/screens_path.dart';
import 'package:nectar_app/utils/users_info.dart';
import 'package:nectar_app/views/components/common_action_button.dart';
import 'package:nectar_app/views/components/common_body_text.dart';
import 'package:nectar_app/views/components/common_checkout_expansion.dart';
import 'package:nectar_app/views/components/common_headline_text.dart';
import 'package:nectar_app/views/components/common_show_dialog.dart';
import 'package:nectar_app/views/components/common_small_body_text.dart';
import 'package:nectar_app/views/components/common_title_text.dart';
import 'package:shimmer/shimmer.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String userId = "";
  double totalPrice = 00;
  bool dataEmpty = true;

  double calculateTotal({required List myList}) {
    Future.delayed(const Duration(seconds: 0), () {
      totalPrice = 00;
      for (int i = 0; i < myList.length; i++) {
        totalPrice += myList[i]['price'] * myList[i]['quantity'];
      }
      setState(() {});
    });
    return totalPrice;
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
              child: const Center(child: CommonHeadlineText(title: "My Cart")),
            ),
            const Divider(),
            FutureBuilder(
              future: FirestoreHelper.firestoreHelper.getCartData(uid: userId),
              builder: (context, snapShot) {
                if (snapShot.hasData) {
                  QuerySnapshot<Map<String, dynamic>>? userData = snapShot.data;

                  List<QueryDocumentSnapshot<Map<String, dynamic>>> allDocs =
                      userData!.docs;
                  calculateTotal(myList: allDocs);
                  if (allDocs.isEmpty) {
                    dataEmpty = true;
                    return Padding(
                      padding: EdgeInsets.only(top: h * 0.2),
                      child: Column(
                        children: [
                          Icon(
                            Icons.shopping_bag_outlined,
                            size: 200,
                            color: Globals.greenColor,
                          ),
                          Text(
                            "Cart Is Empty",
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
                                    );
                                    Navigator.pushNamed(context,
                                        ScreensPath.productDetailScreen,
                                        arguments: productData);
                                  },
                                  child: SizedBox(
                                    height: h * 0.14,
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
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "${allDocs[i].data()['name']}",
                                                      style: const TextStyle(
                                                        fontSize: 17,
                                                      ),
                                                    ),
                                                    Transform.translate(
                                                      offset:
                                                          Offset(w * 0.03, 0),
                                                      child: IconButton(
                                                        onPressed: () async {
                                                          CommonShowDialog.show(
                                                              context: NavKey
                                                                  .navKey
                                                                  .currentContext!);
                                                          await FirestoreHelper
                                                              .firestoreHelper
                                                              .deleteParticularCartData(
                                                                  uid: userId,
                                                                  id: allDocs[i]
                                                                          .data()[
                                                                      'id']);
                                                          CommonShowDialog.close(
                                                              context: NavKey
                                                                  .navKey
                                                                  .currentContext!);
                                                          setState(() {});
                                                        },
                                                        icon: const Icon(
                                                          Icons.close,
                                                          size: 27,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Transform.translate(
                                                  offset: Offset(0, -h * 0.02),
                                                  child: CommonBodyText(
                                                    text:
                                                        "${allDocs[i].data()['subTitle']}",
                                                  ),
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
                                                        GestureDetector(
                                                          onTap: () async {
                                                            if (allDocs[i]
                                                                        .data()[
                                                                    'quantity'] >
                                                                1) {
                                                              CommonShowDialog
                                                                  .show(
                                                                      context:
                                                                          context);
                                                              await FirestoreHelper
                                                                  .firestoreHelper
                                                                  .decreseQuantity(
                                                                      uid:
                                                                          userId,
                                                                      id: allDocs[i]
                                                                              .data()[
                                                                          'id'],
                                                                      quantity:
                                                                          allDocs[i]
                                                                              .data()['quantity']);

                                                              CommonShowDialog
                                                                  .close(
                                                                      context:
                                                                          context);
                                                              setState(() {});
                                                            } else {
                                                              CommonShowDialog.show(
                                                                  context: NavKey
                                                                      .navKey
                                                                      .currentContext!);
                                                              await FirestoreHelper
                                                                  .firestoreHelper
                                                                  .deleteParticularCartData(
                                                                      uid:
                                                                          userId,
                                                                      id: allDocs[i]
                                                                              .data()[
                                                                          'id']);
                                                              CommonShowDialog.close(
                                                                  context: NavKey
                                                                      .navKey
                                                                      .currentContext!);
                                                              setState(() {});
                                                            }
                                                          },
                                                          child: Container(
                                                            height: h * 0.045,
                                                            width: w * 0.095,
                                                            alignment: Alignment
                                                                .center,
                                                            decoration:
                                                                BoxDecoration(
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .grey,
                                                                  width: 0.7),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15),
                                                            ),
                                                            child: const Icon(
                                                              Icons
                                                                  .remove_outlined,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: w * 0.09,
                                                          child: Center(
                                                            child: Text(
                                                              "${allDocs[i].data()['quantity']}",
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 17,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () async {
                                                            CommonShowDialog
                                                                .show(
                                                                    context:
                                                                        context);
                                                            await FirestoreHelper
                                                                .firestoreHelper
                                                                .increseQuantity(
                                                                    uid: userId,
                                                                    id: allDocs[i]
                                                                            .data()[
                                                                        'id'],
                                                                    quantity: allDocs[i]
                                                                            .data()[
                                                                        'quantity']);

                                                            CommonShowDialog
                                                                .close(
                                                                    context:
                                                                        context);
                                                            setState(() {});
                                                          },
                                                          child: Container(
                                                            height: h * 0.045,
                                                            width: w * 0.095,
                                                            alignment: Alignment
                                                                .center,
                                                            decoration:
                                                                BoxDecoration(
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .grey,
                                                                  width: 0.7),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15),
                                                            ),
                                                            child: Icon(
                                                              Icons.add,
                                                              color: Globals
                                                                  .greenColor,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Text(
                                                      "\$ ${allDocs[i].data()['price']}",
                                                      style: const TextStyle(
                                                        fontSize: 17,
                                                      ),
                                                    )
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
      floatingActionButton: (dataEmpty)
          ? null
          : Padding(
              padding: EdgeInsets.only(left: w * 0.08),
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            height: h / 2,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5)),
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: h * 0.03,
                                bottom: h * 0.03,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: w * 0.06,
                                      right: w * 0.06,
                                      bottom: h * 0.02,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const CommonHeadlineText(
                                            title: "Checkout"),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child:
                                              const Icon(Icons.close_rounded),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Divider(),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: w * 0.06,
                                      right: w * 0.06,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const CommonChechoutExpansion(
                                          title: "Delivery",
                                          subTitle: "Select Method",
                                        ),
                                        CommonChechoutExpansion(
                                          title: "Payment",
                                          widget: Container(
                                            height: h * 0.04,
                                            width: w * 0.11,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              image: const DecorationImage(
                                                image: NetworkImage(
                                                    "https://cdn.vox-cdn.com/thumbor/FtAV-Waa1rTPheAkxv3o4i0MVf0=/0x0:1000x1000/1200x800/filters:focal(421x430:581x590)/cdn.vox-cdn.com/uploads/chorus_image/image/62800797/Mastercard_logo.0.jpg"),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const CommonChechoutExpansion(
                                          title: "Promo Code",
                                          subTitle: "Pick discount",
                                        ),
                                        CommonChechoutExpansion(
                                          title: "Total Cost",
                                          subTitle:
                                              "\$ ${totalPrice.toStringAsFixed(2)}",
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsets.only(top: h * 0.01),
                                          child: RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text:
                                                      "By placing an order you agree to our",
                                                  style: TextStyle(
                                                    color: Colors.grey.shade600,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: "  Terms",
                                                  style: TextStyle(
                                                    color: Globals.greenColor,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: "  And",
                                                  style: TextStyle(
                                                    color: Colors.grey.shade600,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: "  Conditions",
                                                  style: TextStyle(
                                                    color: Globals.greenColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsets.only(top: h * 0.02),
                                          child: GestureDetector(
                                            onTap: () async {
                                              //TODO : Make new collection all successfully order show there
                                              CommonShowDialog.show(
                                                  context: context);

                                              var productData;
                                              var data = await FirestoreHelper
                                                  .firestoreHelper
                                                  .getCartData(uid: userId);

                                              productData = data.docs;

                                              var dt = DateTime.now();

                                              String time =
                                                  "${dt.year}:${dt.month}:${dt.day} ${dt.hour}:${dt.minute}:${dt.second}";

                                              Map<String, dynamic> orders = {
                                                'id': time,
                                                'date':
                                                    DateFormat("MMMM, dd, yyyy")
                                                        .format(DateTime.now())
                                                        .toString(),
                                                'items': productData.length,
                                                'total_price': totalPrice
                                                    .toStringAsFixed(2),
                                              };

                                              await FirestoreHelper
                                                  .firestoreHelper
                                                  .insertOrder(
                                                time: time,
                                                uid: userId,
                                                orders: orders,
                                              );

                                              // Insert Records
                                              for (int index = 0;
                                                  index < productData.length;
                                                  index++) {
                                                await FirestoreHelper
                                                    .firestoreHelper
                                                    .deleteParticularCartData(
                                                        uid: userId,
                                                        id: productData[index]
                                                            .data()['id']);

                                                await FirestoreHelper
                                                    .firestoreHelper
                                                    .insertProductOfOrder(
                                                  uid: userId,
                                                  productId: productData[index]
                                                      .data()['id'],
                                                  image: productData[index]
                                                      .data()['image1'],
                                                  name: productData[index]
                                                      .data()['name'],
                                                  price: productData[index]
                                                      .data()['price']
                                                      .toString(),
                                                  quantity: productData[index]
                                                      .data()['quantity']
                                                      .toString(),
                                                  orderId: time,
                                                  date: DateFormat(
                                                          "MMMM, dd, yyyy")
                                                      .format(DateTime.now())
                                                      .toString(),
                                                );
                                              }

                                              CommonShowDialog.close(
                                                  context: context);

                                              Navigator.pushNamed(
                                                context,
                                                ScreensPath.orderAcceptedScreen,
                                              );
                                            },
                                            onLongPress: () {
                                              Navigator.pop(context);
                                              showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Container(
                                                      height: h / 1.7,
                                                      width: w * 8,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          GestureDetector(
                                                            onTap: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: const Icon(
                                                                Icons.close),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: h *
                                                                        0.01),
                                                            child: Column(
                                                              children: [
                                                                Image.asset(
                                                                    ImagesPath
                                                                        .error),
                                                                Padding(
                                                                  padding: EdgeInsets.only(
                                                                      top: h *
                                                                          0.04),
                                                                  child:
                                                                      const CommonTitleText(
                                                                    title:
                                                                        "Oops! Order Failed",
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsets.only(
                                                                      top: h *
                                                                          0.02),
                                                                  child:
                                                                      CommonSmallBodyText(
                                                                    text:
                                                                        "Something went tembly wrong.",
                                                                    color: Colors
                                                                        .grey
                                                                        .shade700,
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsets.only(
                                                                      top: h *
                                                                          0.06),
                                                                  child:
                                                                      GestureDetector(
                                                                    onTap: () {
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    child:
                                                                        const CommonActionButton(
                                                                      name:
                                                                          "Please Try Again",
                                                                    ),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsets.only(
                                                                      top: h *
                                                                          0.02),
                                                                  child:
                                                                      GestureDetector(
                                                                    onTap: () {
                                                                      Navigator.pushNamedAndRemoveUntil(
                                                                          context,
                                                                          ScreensPath
                                                                              .homeScreen,
                                                                          (route) =>
                                                                              false);
                                                                    },
                                                                    child:
                                                                        const Text(
                                                                      "Back to home",
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            18,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            child: const CommonActionButton(
                                              name: "Place Order",
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: const CommonActionButton(
                      name: "Go to Checkout",
                    ),
                  ),
                  Positioned(
                    left: w * 0.67,
                    top: h * 0.021,
                    child: Container(
                      height: h * 0.028,
                      width: w * 0.2,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.transparent.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        "  \$ ${totalPrice.toStringAsFixed(2)}  ",
                        style: const TextStyle(color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
