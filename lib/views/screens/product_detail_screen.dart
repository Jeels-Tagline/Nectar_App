// ignore_for_file: unused_local_variable, non_constant_identifier_names, use_build_context_synchronously

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:nectar_app/helpers/firestore_helpers.dart';
import 'package:nectar_app/main.dart';
import 'package:nectar_app/models/globals/globals.dart';
import 'package:nectar_app/models/product_models.dart';
import 'package:nectar_app/navigator.dart';
import 'package:nectar_app/utils/screens_path.dart';
import 'package:nectar_app/views/components/common_action_button.dart';
import 'package:nectar_app/views/components/common_body_text.dart';
import 'package:nectar_app/views/components/common_small_body_text.dart';
import 'package:nectar_app/views/components/common_title_text.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final CarouselController carouselController = CarouselController();
  int currentIndex = 0;
  late ProductModel productData;

  bool detail_arrow = false;
  int quantity = 1;
  bool favorite = false;

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
    productData = ModalRoute.of(context)!.settings.arguments as ProductModel;
    List images = [
      productData.image1,
      productData.image2,
      productData.image3,
    ];
    quantity = productData.quantity ?? 1;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: h * 0.45,
              width: w,
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
                      padding: EdgeInsets.only(top: h * 0.01),
                      child: StatefulBuilder(builder: (context, setStateJ) {
                        return Column(
                          children: [
                            SizedBox(
                              height: h * 0.25,
                              width: w,
                              child: CarouselSlider.builder(
                                itemCount: images.length,
                                itemBuilder: (BuildContext context,
                                        int itemIndex, int pageViewIndex) =>
                                    Image.network(images[itemIndex]),
                                options: CarouselOptions(
                                  autoPlay: true,
                                  enlargeCenterPage: true,
                                  viewportFraction: 0.9,
                                  aspectRatio: 2.0,
                                  initialPage: 2,
                                  onPageChanged: (index, _) {
                                    setStateJ(() {
                                      currentIndex = index;
                                    });
                                  },
                                ),
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
                              'favourite': productData.favourite ?? false,
                            };
                            await FirestoreHelper.firestoreHelper
                                .insertFavouriteData(
                              uid: userId,
                              productData: data,
                            );
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context)
                              ..clearSnackBars()
                              ..showSnackBar(
                                const SnackBar(
                                  content:
                                      Text("Product add to Favourite....."),
                                  backgroundColor: Colors.green,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );

                            setState(() {
                              favorite = true;
                            });
                          } else {
                            showDialog(
                              context: NavKey.navKey.currentContext!,
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
                            await FirestoreHelper.firestoreHelper
                                .deleteParticularFavouriteData(
                                    uid: userId, id: productData.id);
                            Navigator.pop(NavKey.navKey.currentContext!);

                            ScaffoldMessenger.of(context)
                              ..clearSnackBars()
                              ..showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      "Product remove from Favourite....."),
                                  backgroundColor: Colors.red,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );

                            setState(() {
                              favorite = false;
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
                                  (quantity > 1) ? quantity-- : null;
                                  productData.quantity = quantity;
                                  setStateQty(() {});
                                },
                                icon: const Icon(
                                  Icons.remove,
                                  size: 28,
                                  color: Colors.grey,
                                ),
                              ),
                              Container(
                                height: h * 0.05,
                                width: w * 0.1,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey, width: 0.7),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Text(
                                  "$quantity",
                                  style: const TextStyle(
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  quantity++;
                                  productData.quantity = quantity;
                                  setStateQty(() {});
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
                        CommonTitleText(title: "\$ ${productData.price}"),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: h * 0.02),
                    child: ExpansionTile(
                      onExpansionChanged: (change) {
                        detail_arrow = change;
                        setState(() {});
                      },
                      title: Transform.translate(
                        offset: Offset(w * -0.04, 0),
                        child: const Text("Product Detail"),
                      ),
                      trailing: Transform.translate(
                        offset: Offset(w * 0.05, 0),
                        child: (detail_arrow)
                            ? Image.asset("assets/icons/down_arrow.png")
                            : Image.asset("assets/icons/forward_arrow.png"),
                      ),
                      children: [
                        CommonSmallBodyText(
                          text: "${productData.detail}\n",
                          color: Colors.grey.shade700,
                        ),
                      ],
                    ),
                  ),
                  ExpansionTile(
                    title: Transform.translate(
                      offset: Offset(w * -0.04, 0),
                      child: const Text("Nutritions"),
                    ),
                    trailing: Transform.translate(
                      offset: Offset(w * 0.05, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: h * 0.03,
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
                          Image.asset("assets/icons/forward_arrow.png"),
                        ],
                      ),
                    ),
                  ),
                  ExpansionTile(
                    title: Transform.translate(
                      offset: Offset(w * -0.04, 0),
                      child: const Text("Review"),
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
                          Image.asset("assets/icons/forward_arrow.png"),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: h * 0.04),
                    child: GestureDetector(
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
                        child: const CommonActionButton(name: "Add To Basket")),
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
