// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:nectar_app/helpers/firestore_helpers.dart';
import 'package:nectar_app/models/globals/globals.dart';
import 'package:nectar_app/models/product_models.dart';
import 'package:nectar_app/utils/font_family.dart';
import 'package:nectar_app/utils/screens_path.dart';

class CommonProduct extends StatelessWidget {
  final ProductModel productData;
  final Function()? onTap;
  final String userId;
  const CommonProduct({
    super.key,
    required this.productData,
    required this.userId,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, ScreensPath.productDetailScreen,
            arguments: productData);
      },
      child: Container(
        height: h * 0.26,
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
              SizedBox(
                height: h * 0.1,
                width: w,
                child: Image.network(
                  productData.image1,
                ),
              ),
              Text(
                productData.name,
                style: const TextStyle(
                  fontSize: 17,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                productData.subTitle,
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: FontFamily.medium,
                  color: Colors.grey.shade500,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: h * 0.013),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "\$ ${productData.price}",
                        style: const TextStyle(
                          fontSize: 17,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return const AlertDialog(
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Loading'),
                                  CircularProgressIndicator(),
                                ],
                              ),
                            );
                          },
                        );

                        Map<String, dynamic> data = {
                          'id': productData.id,
                          'name': productData.name,
                          'subTitle': productData.subTitle,
                          'price': productData.price,
                          'detail': productData.detail,
                          'nutrition': productData.nutrition,
                          'review': productData.review,
                          'type': productData.type,
                          'image1': productData.image1,
                          'image2': productData.image2,
                          'image3': productData.image3,
                          'quantity': productData.quantity ?? 1,
                        };
                        // await FirestoreHelper.firestoreHelper.updateCart(
                        //   uid: userId,
                        //   productData: [data],
                        // );

                        await FirestoreHelper.firestoreHelper.insertCartData(
                          uid: userId,
                          productData: data,
                        );
                        Navigator.pop(context);

                        ScaffoldMessenger.of(context)
                          ..clearSnackBars()
                          ..showSnackBar(
                            const SnackBar(
                              content: Text("Product add to bag....."),
                              backgroundColor: Colors.green,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                      },
                      child: Container(
                        height: h * 0.055,
                        width: w * 0.12,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Globals.greenColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Icon(
                          Icons.add,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
