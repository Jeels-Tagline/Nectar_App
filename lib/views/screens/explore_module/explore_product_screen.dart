import 'package:flutter/material.dart';
import 'package:nectar_app/models/globals/globals.dart';
import 'package:nectar_app/models/hive_product_models.dart';
import 'package:nectar_app/models/product_models.dart';
import 'package:nectar_app/utils/images_path.dart';
import 'package:nectar_app/utils/user_data.dart';
import 'package:nectar_app/views/components/common_headline_text.dart';
import 'package:nectar_app/views/components/common_product.dart';

class ExploreProductScreen extends StatefulWidget {
  const ExploreProductScreen({super.key});

  @override
  State<ExploreProductScreen> createState() => _ExploreProductScreenState();
}

class _ExploreProductScreenState extends State<ExploreProductScreen> {
  late List<HiveProductModel> listOfAllData = [];
  late List<HiveProductModel> productData = [];

  setData({required String name, List<HiveProductModel>? givenList}) {
    if (name != '') {
      productData.clear();
      listOfAllData = Globals.boxListOfProduct
          .get(0, defaultValue: [])?.cast<HiveProductModel>();
      for (int i = 0; i < listOfAllData.length; i++) {
        if (listOfAllData[i].type == name.toLowerCase()) {
          productData.add(listOfAllData[i]);
        }
      }
      setState(() {});
    } else {
      productData.clear();

      for (int i = 0; i < givenList!.length; i++) {
        productData.add(givenList[i]);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // getUserId();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    Map<String, dynamic> data =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    setData(name: data['name'] ?? '', givenList: data['list']);
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.only(top: h * 0.07, bottom: h * 0.02),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(right: w * 0.00),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    ),
                    CommonHeadlineText(title: data['showTitle']),
                    Padding(
                      padding: EdgeInsets.only(left: w * 0.04, right: w * 0.04),
                      child: Image.asset(ImagesPath.filter),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: w * 0.04, right: w * 0.04),
                child: Transform.translate(
                  offset: Offset(0, -h * 0.025),
                  child: GridView.count(
                    shrinkWrap: true,
                    // childAspectRatio: ((w / 2) / (h / 3.37)),
                    childAspectRatio: ((w / 2) / (h / 3.33)),
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: w * 0.02,
                    crossAxisSpacing: h * 0.02,
                    children: List.generate(
                      productData.length,
                      (index) => CommonProduct(
                        userId: UserData.uid,
                        productData: ProductModel(
                          id: productData[index].id,
                          name: productData[index].name,
                          subTitle: productData[index].subTitle,
                          price: productData[index].price,
                          detail: productData[index].detail,
                          nutrition: productData[index].nutrition,
                          review: productData[index].review,
                          type: productData[index].type,
                          image1: productData[index].image1,
                          image2: productData[index].image2,
                          image3: productData[index].image3,
                          exclusiveOffer: productData[index].exclusiveOffer,
                        ),
                      ),
                    ),
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
