// ignore_for_file: unused_local_variable, non_constant_identifier_names, use_build_context_synchronously, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:nectar_app/helpers/firestore_helpers.dart';
import 'package:nectar_app/helpers/provider/quentity_provider.dart';
import 'package:nectar_app/models/globals/globals.dart';
import 'package:nectar_app/models/product_models.dart';
import 'package:nectar_app/navigator.dart';
import 'package:nectar_app/utils/images_path.dart';
import 'package:nectar_app/utils/screens_path.dart';
import 'package:nectar_app/utils/user_data.dart';
import 'package:nectar_app/views/components/common_action_button.dart';
import 'package:nectar_app/views/components/common_body_text.dart';
import 'package:nectar_app/views/components/common_show_dialog.dart';
import 'package:nectar_app/views/components/common_small_body_text.dart';
import 'package:nectar_app/views/components/common_scaffold_messenger.dart';
import 'package:nectar_app/views/components/common_title_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int currentIndex = 0;
  double offerPrice = 0;
  late ProductModel productData;
  PageController pageController = PageController();
  bool detail_arrow = false;
  int quantity = 1;
  bool favorite = false;
  var userData;
  List images = [];

  // String userId = "";
  // getUserId() async {
  //   userId = sharedPreferences!.getString(UsersInfo.userId) ?? '';
  //   setState(() {});
  // }

  checkFavourite({required String id}) async {
    var data = await FirestoreHelper.firestoreHelper
        .getFavouriteData(uid: UserData.uid);

    userData = data.docs;

    for (int i = 0; i < userData.length; i++) {
      if (userData[i].data()['id'] == id) {
        favorite = true;
      }
    }
    setState(() {});
    // Future.delayed(Duration.zero, () => {setState(() {})});
  }

  setPrice() {
    double per;
    double discount;
    per = productData.exclusiveOffer / 100;
    discount = productData.price * per;
    offerPrice = productData.price - discount;
  }

  @override
  void initState() {
    super.initState();
    // getUserId();
    pageController.addListener(() {
      setState(() {
        currentIndex = pageController.page!.round();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    productData = ModalRoute.of(context)!.settings.arguments as ProductModel;
    images = [
      productData.image1,
      productData.image2,
      productData.image3,
    ];
    Provider.of<QuantityProvider>(context, listen: true)
        .quantityModel
        .quantity = productData.quantity ?? 1;
    // favorite = productData.favourite ?? false;
    checkFavourite(id: productData.id);
    setPrice();
    // favorite = productData.favourite ?? false;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: h * 0.45,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xffF2F3F2),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(top: h * 0.07),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, ScreensPath.cartScreen);
                          },
                          icon: const Icon(
                            Icons.shopping_cart_outlined,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: StatefulBuilder(builder: (context, setStateJ) {
                        return Column(
                          children: [
                            SizedBox(
                              height: h * 0.25,
                              width: double.infinity,
                              child: PageView.builder(
                                controller: pageController,
                                itemCount: images.length,
                                onPageChanged: (index) {
                                  setState(() {
                                    currentIndex = index;
                                  });
                                },
                                itemBuilder: (context, index) {
                                  return Image.network(
                                    images[index],
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: h * 0.02),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: images.asMap().entries.map((e) {
                                  return Container(
                                    width: (currentIndex == e.key)
                                        ? w * 0.05
                                        : w * 0.010,
                                    height: h * 0.005,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 3),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: (currentIndex == e.key)
                                          ? Globals.greenColor
                                          : Colors.grey,
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: h * 0.01,
                bottom: h * 0.01,
                left: w * 0.04,
                right: w * 0.04,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CommonTitleText(title: productData.name),
                      IconButton(
                        onPressed: () async {
                          if (favorite == false) {
                            CommonShowDialog.show(context: context);
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
                              'favourite': productData.favourite ?? false,
                              'exclusiveOffer': productData.exclusiveOffer,
                            };
                            await FirestoreHelper.firestoreHelper
                                .insertFavouriteData(
                              uid: UserData.uid,
                              productData: data,
                            );
                            CommonShowDialog.close(context: context);
                            CommonScaffoldMessenger.success(
                              context: context,
                              message: AppLocalizations.of(context)!
                                  .productAddedToFavourite,
                            );

                            setState(() {
                              favorite = true;
                              productData.favourite = true;
                            });
                          } else {
                            CommonShowDialog.show(
                                context: NavKey.navKey.currentContext!);
                            await FirestoreHelper.firestoreHelper
                                .deleteParticularFavouriteData(
                                    uid: UserData.uid, id: productData.id);
                            CommonShowDialog.close(
                                context: NavKey.navKey.currentContext!);

                            CommonScaffoldMessenger.failed(
                              context: context,
                              message: AppLocalizations.of(context)!
                                  .productRemoveFromFavourite,
                            );

                            setState(() {
                              favorite = false;
                              productData.favourite = false;
                            });
                          }
                        },
                        icon: (favorite == false)
                            ? const Icon(Icons.favorite_border)
                            : const Icon(Icons.favorite),
                        color: (favorite == false) ? Colors.black : Colors.red,
                      ),
                    ],
                  ),
                  CommonBodyText(text: productData.subTitle),
                  Padding(
                    padding: EdgeInsets.only(top: h * 0.02),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        StatefulBuilder(builder: (context, setStateQty) {
                          return Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  Provider.of<QuantityProvider>(context,
                                          listen: false)
                                      .decreseQuantity(
                                          quantity: productData.quantity ?? 1);
                                  // (quantity > 1) ? quantity-- : null;
                                  productData.quantity =
                                      Provider.of<QuantityProvider>(context,
                                              listen: false)
                                          .quantityModel
                                          .quantity;
                                  // setStateQty(() {});
                                },
                                icon: const Icon(
                                  Icons.remove,
                                  size: 28,
                                  color: Colors.grey,
                                ),
                              ),
                              Container(
                                height: 43,
                                width: 43,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey, width: 0.7),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Text(
                                  "${Provider.of<QuantityProvider>(context, listen: false).quantityModel.quantity}",
                                  style: const TextStyle(
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  Provider.of<QuantityProvider>(context,
                                          listen: false)
                                      .increseQuantity(
                                          quantity: productData.quantity ?? 1);
                                  productData.quantity =
                                      Provider.of<QuantityProvider>(context,
                                              listen: false)
                                          .quantityModel
                                          .quantity;
                                  // setStateQty(() {});
                                },
                                icon: Icon(
                                  Icons.add,
                                  size: 28,
                                  color: Globals.greenColor,
                                ),
                              ),
                            ],
                          );
                        }),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (productData.exclusiveOffer != 0)
                                  Text(
                                    "-${productData.exclusiveOffer}%  ",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.red,
                                    ),
                                  ),
                                CommonTitleText(
                                    title:
                                        "\$ ${offerPrice.toStringAsFixed(2)}"),
                              ],
                            ),
                            if (productData.exclusiveOffer != 0)
                              Row(
                                children: [
                                  const Text(
                                    "MRP : ",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    "\$${productData.price.toStringAsFixed(2)}",
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: h * 0.02),
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        onExpansionChanged: (change) {
                          detail_arrow = change;
                          // setState(() {});
                        },
                        title: Transform.translate(
                          offset: Offset(w * -0.04, 0),
                          child: Text(
                            AppLocalizations.of(context)!.productDetail,
                          ),
                        ),
                        trailing: Transform.translate(
                          offset: Offset(w * 0.05, 0),
                          child: (detail_arrow)
                              ? Image.asset(ImagesPath.downArrow)
                              : Image.asset(ImagesPath.forwardArrow),
                        ),
                        children: [
                          CommonSmallBodyText(
                            text: "${productData.detail}\n",
                            color: Colors.grey.shade700,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Theme(
                    data: Theme.of(context)
                        .copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      title: Transform.translate(
                        offset: Offset(w * -0.04, 0),
                        child: Text(
                          AppLocalizations.of(context)!.nutritions,
                        ),
                      ),
                      trailing: Transform.translate(
                        offset: Offset(w * 0.05, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              height: 25,
                              padding: const EdgeInsets.all(5),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Text(
                                productData.nutrition,
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                            ),
                            SizedBox(
                              width: w * 00.03,
                            ),
                            Image.asset(ImagesPath.forwardArrow),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Theme(
                    data: Theme.of(context)
                        .copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      title: Transform.translate(
                        offset: Offset(w * -0.04, 0),
                        child: Text(
                          AppLocalizations.of(context)!.review,
                        ),
                      ),
                      trailing: Transform.translate(
                        offset: Offset(w * 0.05, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ...List.generate(productData.review, (index) {
                              return const Icon(
                                Icons.star,
                                color: Colors.orange,
                              );
                            }),
                            SizedBox(
                              width: w * 00.03,
                            ),
                            Image.asset(ImagesPath.forwardArrow),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: h * 0.04),
                    child: GestureDetector(
                      onTap: () async {
                        CommonShowDialog.show(context: context);

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
                          'exclusiveOffer': productData.exclusiveOffer,
                        };

                        await FirestoreHelper.firestoreHelper.insertCartData(
                          uid: UserData.uid,
                          productData: data,
                        );
                        CommonShowDialog.close(context: context);

                        CommonScaffoldMessenger.success(
                          context: context,
                          message:
                              AppLocalizations.of(context)!.productAddedToCart,
                        );
                      },
                      child: CommonActionButton(
                        name: AppLocalizations.of(context)!.addToBasket,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
