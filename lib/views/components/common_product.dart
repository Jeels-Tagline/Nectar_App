// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables, use_build_context_synchronously, must_be_immutable

import 'package:flutter/material.dart';
import 'package:nectar_app/helpers/firestore_helpers.dart';
import 'package:nectar_app/models/globals/globals.dart';
import 'package:nectar_app/models/product_models.dart';
import 'package:nectar_app/utils/font_family.dart';
import 'package:nectar_app/utils/screens_path.dart';
import 'package:nectar_app/views/components/common_scaffold_messenger.dart';
import 'package:nectar_app/views/components/common_show_dialog.dart';

class CommonProduct extends StatefulWidget {
  final ProductModel productData;
  final Function()? onTap;
  final String userId;
  const CommonProduct({
    required this.productData,
    this.onTap,
    required this.userId,
    super.key,
  });

  @override
  State<CommonProduct> createState() => _CommonProductState();
}

class _CommonProductState extends State<CommonProduct> {
  double? offerPrice;

  setPrice() {
    double per;
    double discount;
    per = widget.productData.exclusiveOffer / 100;
    discount = widget.productData.price * per;
    offerPrice = widget.productData.price - discount;
  }

  @override
  void initState() {
    super.initState();
    setPrice();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, ScreensPath.productDetailScreen,
            arguments: widget.productData);
      },
      child: Container(
        height: 250,
        width: 170,
        padding: const EdgeInsets.all(5),
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
                height: 100,
                width: double.infinity,
                child: Image.network(
                  widget.productData.image1,
                ),
              ),
              Text(
                widget.productData.name,
                style: const TextStyle(
                  fontSize: 17,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                widget.productData.subTitle,
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: FontFamily.medium,
                  color: Colors.grey.shade500,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "\$ ${offerPrice!.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 17,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        CommonShowDialog.show(context: context);

                        Map<String, dynamic> data = {
                          'id': widget.productData.id,
                          'name': widget.productData.name,
                          'subTitle': widget.productData.subTitle,
                          // 'price': offerPrice,
                          'price': widget.productData.price,
                          'detail': widget.productData.detail,
                          'nutrition': widget.productData.nutrition,
                          'review': widget.productData.review,
                          'type': widget.productData.type,
                          'image1': widget.productData.image1,
                          'image2': widget.productData.image2,
                          'image3': widget.productData.image3,
                          'quantity': widget.productData.quantity ?? 1,
                          'exclusiveOffer': widget.productData.exclusiveOffer,
                        };

                        List<Map<String, dynamic>> demo = [];
                        demo.add(data);

                        await Globals.boxCart.add(demo);

                        await FirestoreHelper.firestoreHelper.insertCartData(
                          uid: widget.userId,
                          productData: data,
                        );
                        CommonShowDialog.close(context: context);

                        CommonScaffoldMessenger.success(
                            context: context,
                            message: "Product add to bag.....");
                      },
                      child: Container(
                        height: 50,
                        width: 50,
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
