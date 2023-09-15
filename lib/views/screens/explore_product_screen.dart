import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nectar_app/helpers/firestore_helpers.dart';
import 'package:nectar_app/main.dart';
import 'package:nectar_app/models/globals/globals.dart';
import 'package:nectar_app/models/product_models.dart';
import 'package:nectar_app/views/components/common_headline_text.dart';
import 'package:nectar_app/views/components/common_product.dart';
import 'package:shimmer/shimmer.dart';

class ExploreProductScreen extends StatefulWidget {
  const ExploreProductScreen({super.key});

  @override
  State<ExploreProductScreen> createState() => _ExploreProductScreenState();
}

class _ExploreProductScreenState extends State<ExploreProductScreen> {
  String userId = "";

  getUserId() async {
    userId = sharedPreferences!.getString('isUserID') ?? '';

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
    String name = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.only(top: h * 0.07, bottom: h * 0.02),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(right: w * 0.03),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    ),
                    CommonHeadlineText(title: name),
                    Image.asset("assets/icons/filter.png"),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: w * 0.04, right: w * 0.04),
                child: Transform.translate(
                  offset: Offset(0, -h * 0.025),
                  child: FutureBuilder(
                    future: FirestoreHelper.firestoreHelper
                        .getParticularProductData(type: name.toLowerCase()),
                    builder: (context, snapShot) {
                      if (snapShot.hasError) {
                        return Text("${snapShot.error}");
                      } else if (snapShot.hasData) {
                        QuerySnapshot<Map<String, dynamic>>? product =
                            snapShot.data;

                        List<QueryDocumentSnapshot<Map<String, dynamic>>>
                            productData = product!.docs;

                        return GridView.count(
                          shrinkWrap: true,
                          childAspectRatio: ((w / 2) / (h / 3.37)),
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          mainAxisSpacing: w * 0.02,
                          crossAxisSpacing: h * 0.02,
                          children: List.generate(
                            productData.length,
                            (index) => CommonProduct(
                              userId: userId,
                              productData: ProductModel(
                                id: productData[index].data()['id'],
                                name: productData[index].data()['name'],
                                subTitle: productData[index].data()['subTitle'],
                                price: double.parse(
                                    productData[index].data()['price']),
                                detail: productData[index].data()['detail'],
                                nutrition:
                                    productData[index].data()['nutrition'],
                                review: int.parse(
                                    productData[index].data()['review']),
                                type: productData[index].data()['type'],
                                image1: productData[index].data()['image1'],
                                image2: productData[index].data()['image2'],
                                image3: productData[index].data()['image3'],
                              ),
                            ),
                          ),
                        );
                      }
                      return Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: GridView.count(
                          shrinkWrap: true,
                          childAspectRatio: ((w / 2) / (h / 3.37)),
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          mainAxisSpacing: w * 0.02,
                          crossAxisSpacing: h * 0.02,
                          children: List.generate(
                            4,
                            (index) => Container(
                              width: w * 0.4,
                              padding: EdgeInsets.only(
                                top: h * 0.01,
                                bottom: h * 0.01,
                                left: w * 0.01,
                                right: w * 0.01,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade400),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: h * 0.1,
                                      width: w,
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: h * 00.01),
                                      child: Container(
                                        height: h * 0.02,
                                        width: w,
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: h * 00.01),
                                      child: Container(
                                        height: h * 0.01,
                                        width: w,
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: h * 0.013),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            height: h * 0.03,
                                            width: w * 0.15,
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(7),
                                            ),
                                          ),
                                          Container(
                                            height: h * 0.055,
                                            width: w * 0.12,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: Globals.greenColor,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
