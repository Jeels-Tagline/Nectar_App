// ignore_for_file: deprecated_member_use, unrelated_type_equality_checks

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nectar_app/helpers/firestore_helpers.dart';
import 'package:nectar_app/main.dart';
import 'package:nectar_app/models/globals/globals.dart';
import 'package:nectar_app/models/product_models.dart';
import 'package:nectar_app/utils/font_family.dart';
import 'package:nectar_app/utils/screens_path.dart';
import 'package:nectar_app/views/components/common_offer_banner.dart';
import 'package:nectar_app/views/components/common_product.dart';
import 'package:nectar_app/views/components/common_product_shimmer.dart';
import 'package:nectar_app/views/screens/account_screen.dart';
import 'package:nectar_app/views/screens/cart_screen.dart';
import 'package:nectar_app/views/screens/explore_screen.dart';
import 'package:nectar_app/views/screens/favourite_screen.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userId = "";

  getUserId() async {
    userId = sharedPreferences!.getString('isUserID') ?? '';

    setState(() {});
  }

  int _selectedIndex = 0;

  static const images = [
    'assets/banner/banner1.jpg',
    'assets/banner/banner2.jpg',
    'assets/banner/banner3.jpg',
  ];
  final CarouselController carouselController = CarouselController();
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    getUserId(); //*
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        bool? isClose = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Do you want close the app??'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop(true);
                },
                child: const Text('Yes'),
              ),
            ],
          ),
        );

        return isClose ?? false;
      },
      child: Scaffold(
        body: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: h * 0.06),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: SizedBox(
                      height: h * 0.04,
                      child: Image.asset("assets/logos/carot_orange.png"),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: h * 0.01),
                    child: FutureBuilder(
                      future: FirestoreHelper.firestoreHelper
                          .getUserData(uid: userId),
                      builder: (context, snapShot) {
                        if (snapShot.hasError) {
                          return Text("${snapShot.error}");
                        } else if (snapShot.hasData) {
                          QuerySnapshot<Map<String, dynamic>>? userData =
                              snapShot.data;

                          List<QueryDocumentSnapshot<Map<String, dynamic>>>
                              allDocs = userData!.docs;

                          return FittedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.location_on,
                                    color: Colors.grey.shade800),
                                Text(
                                  "${allDocs[0].data()['city']}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        return Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            height: h * 0.025,
                            width: w * 0.6,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(7),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: h * 0.02),
                    child: StatefulBuilder(builder: (context, setStateJ) {
                      return Stack(
                        children: [
                          SizedBox(
                            height: h * 0.123,
                            width: w,
                            child: CarouselSlider.builder(
                              itemCount: images.length,
                              itemBuilder: (BuildContext context, int itemIndex,
                                      int pageViewIndex) =>
                                  Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  image: DecorationImage(
                                    image: AssetImage(images[itemIndex]),
                                  ),
                                ),
                              ),
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
                          Positioned(
                            bottom: 0,
                            top: h * 0.105,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: images.asMap().entries.map((e) {
                                return GestureDetector(
                                  onTap: () =>
                                      carouselController.animateToPage(e.key),
                                  child: Container(
                                    width: (currentIndex == e.key)
                                        ? w * 0.04
                                        : w * 0.016,
                                    height: h * 0.008,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 3),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: (currentIndex == e.key)
                                          ? Globals.greenColor
                                          : Colors.grey,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: h * 0.02,
                      left: w * 0.05,
                      right: w * 0.05,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CommonOfferBanner(
                          offerName: "Exclusive Offer",
                          name: "fruit",
                        ),
                        FutureBuilder(
                          future: FirestoreHelper.firestoreHelper
                              .getParticularProductData(type: 'fruit'),
                          builder: (context, snapShot) {
                            if (snapShot.hasError) {
                              return Text("${snapShot.error}");
                            } else if (snapShot.hasData) {
                              QuerySnapshot<Map<String, dynamic>>? product =
                                  snapShot.data;

                              List<QueryDocumentSnapshot<Map<String, dynamic>>>
                                  productData = product!.docs;

                              return SizedBox(
                                width: w,
                                height: h * 0.28,
                                child: ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemCount: productData.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                          top: h * 0.02, right: w * 0.025),
                                      child: CommonProduct(
                                        userId: userId,
                                        productData: ProductModel(
                                          id: productData[index].data()['id'],
                                          name:
                                              productData[index].data()['name'],
                                          subTitle: productData[index]
                                              .data()['subTitle'],
                                          price: double.parse(productData[index]
                                              .data()['price']),
                                          detail: productData[index]
                                              .data()['detail'],
                                          nutrition: productData[index]
                                              .data()['nutrition'],
                                          review: int.parse(productData[index]
                                              .data()['review']),
                                          type:
                                              productData[index].data()['type'],
                                          image1: productData[index]
                                              .data()['image1'],
                                          image2: productData[index]
                                              .data()['image2'],
                                          image3: productData[index]
                                              .data()['image3'],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            }
                            return const CommonProductShimmer(itemCount: 3);
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: h * 0.03),
                          child: const CommonOfferBanner(
                            offerName: "Best Selling",
                            name: "Baverage",
                          ),
                        ),
                        FutureBuilder(
                          future: FirestoreHelper.firestoreHelper
                              .getParticularProductData(type: 'baverage'),
                          builder: (context, snapShot) {
                            if (snapShot.hasError) {
                              return Text("${snapShot.error}");
                            } else if (snapShot.hasData) {
                              QuerySnapshot<Map<String, dynamic>>? product =
                                  snapShot.data;

                              List<QueryDocumentSnapshot<Map<String, dynamic>>>
                                  productData = product!.docs;

                              return SizedBox(
                                width: w,
                                height: h * 0.28,
                                child: ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemCount: productData.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                          top: h * 0.02, right: w * 0.025),
                                      child: CommonProduct(
                                        userId: userId,
                                        productData: ProductModel(
                                          id: productData[index].data()['id'],
                                          name:
                                              productData[index].data()['name'],
                                          subTitle: productData[index]
                                              .data()['subTitle'],
                                          price: double.parse(productData[index]
                                              .data()['price']),
                                          detail: productData[index]
                                              .data()['detail'],
                                          nutrition: productData[index]
                                              .data()['nutrition'],
                                          review: int.parse(productData[index]
                                              .data()['review']),
                                          type:
                                              productData[index].data()['type'],
                                          image1: productData[index]
                                              .data()['image1'],
                                          image2: productData[index]
                                              .data()['image2'],
                                          image3: productData[index]
                                              .data()['image3'],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            }
                            return const CommonProductShimmer(itemCount: 3);
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: h * 0.03),
                          child: const CommonOfferBanner(
                            offerName: "Bakery",
                            name: "Bakery",
                          ),
                        ),
                        FutureBuilder(
                          future: FirestoreHelper.firestoreHelper
                              .getParticularProductData(type: 'bakery'),
                          builder: (context, snapShot) {
                            if (snapShot.hasError) {
                              return Text("${snapShot.error}");
                            } else if (snapShot.hasData) {
                              QuerySnapshot<Map<String, dynamic>>? product =
                                  snapShot.data;

                              List<QueryDocumentSnapshot<Map<String, dynamic>>>
                                  productData = product!.docs;

                              return SizedBox(
                                width: w,
                                height: h * 0.28,
                                child: ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemCount: productData.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                          top: h * 0.02, right: w * 0.025),
                                      child: CommonProduct(
                                        userId: userId,
                                        productData: ProductModel(
                                          id: productData[index].data()['id'],
                                          name:
                                              productData[index].data()['name'],
                                          subTitle: productData[index]
                                              .data()['subTitle'],
                                          price: double.parse(productData[index]
                                              .data()['price']),
                                          detail: productData[index]
                                              .data()['detail'],
                                          nutrition: productData[index]
                                              .data()['nutrition'],
                                          review: int.parse(productData[index]
                                              .data()['review']),
                                          type:
                                              productData[index].data()['type'],
                                          image1: productData[index]
                                              .data()['image1'],
                                          image2: productData[index]
                                              .data()['image2'],
                                          image3: productData[index]
                                              .data()['image3'],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            }
                            return const CommonProductShimmer(itemCount: 3);
                          },
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(top: h * 0.03, bottom: h * 0.018),
                          child: const CommonOfferBanner(
                            offerName: "Groceries",
                            name: "Rice",
                          ),
                        ),
                        SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    ScreensPath.exploreProductScreen,
                                    arguments: 'Pulses',
                                  );
                                },
                                child: Container(
                                  height: h * 0.11,
                                  width: w * 0.55,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: const Color.fromARGB(
                                        255, 255, 224, 188),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: w * 0.025, right: w * 0.025),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Expanded(
                                          child: Image.asset(
                                              "assets/images/pulses.png"),
                                        ),
                                        SizedBox(
                                          width: w * 0.02,
                                        ),
                                        const Expanded(
                                          flex: 2,
                                          child: Text(
                                            "Pulses",
                                            style: TextStyle(
                                              fontFamily: FontFamily.medium,
                                              fontSize: 19,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: w * 0.04),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      ScreensPath.exploreProductScreen,
                                      arguments: 'Rice',
                                    );
                                  },
                                  child: Container(
                                    height: h * 0.11,
                                    width: w * 0.55,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: const Color(0xffe5f4ea),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: w * 0.025, right: w * 0.025),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Expanded(
                                            child: Image.asset(
                                                "assets/images/rices.png"),
                                          ),
                                          SizedBox(
                                            width: w * 0.02,
                                          ),
                                          const Expanded(
                                            flex: 2,
                                            child: Text(
                                              "Rices",
                                              style: TextStyle(
                                                fontFamily: FontFamily.medium,
                                                fontSize: 19,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        FutureBuilder(
                          future: FirestoreHelper.firestoreHelper
                              .getParticularProductData(type: 'vegetable'),
                          builder: (context, snapShot) {
                            if (snapShot.hasError) {
                              return Text("${snapShot.error}");
                            } else if (snapShot.hasData) {
                              QuerySnapshot<Map<String, dynamic>>? product =
                                  snapShot.data;

                              List<QueryDocumentSnapshot<Map<String, dynamic>>>
                                  productData = product!.docs;

                              return SizedBox(
                                width: w,
                                height: h * 0.28,
                                child: ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemCount: productData.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                          top: h * 0.02, right: w * 0.025),
                                      child: CommonProduct(
                                        userId: userId,
                                        productData: ProductModel(
                                          id: productData[index].data()['id'],
                                          name:
                                              productData[index].data()['name'],
                                          subTitle: productData[index]
                                              .data()['subTitle'],
                                          price: double.parse(productData[index]
                                              .data()['price']),
                                          detail: productData[index]
                                              .data()['detail'],
                                          nutrition: productData[index]
                                              .data()['nutrition'],
                                          review: int.parse(productData[index]
                                              .data()['review']),
                                          type:
                                              productData[index].data()['type'],
                                          image1: productData[index]
                                              .data()['image1'],
                                          image2: productData[index]
                                              .data()['image2'],
                                          image3: productData[index]
                                              .data()['image3'],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            }
                            return const CommonProductShimmer(itemCount: 3);
                          },
                        ),
                        SizedBox(
                          height: h * 0.03,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const ExploreScreen(),
          const CartScreen(),
          const FavouriteScreen(),
          const AccountScreen(),
        ][_selectedIndex],
        bottomNavigationBar: bottomNavigationBar,
      ),
    );
  }

  Widget get bottomNavigationBar {
    return Container(
      height: 80,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(15), topLeft: Radius.circular(15)),
        boxShadow: [
          BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 5),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15.0),
          topRight: Radius.circular(15.0),
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag_outlined),
              label: 'Shop',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Explore',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined),
              label: 'Cart',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border),
              label: 'Favourite',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_outlined),
              label: 'Account',
            ),
          ],
          unselectedItemColor: Colors.black,
          currentIndex: _selectedIndex,
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: true,
          selectedItemColor: Globals.greenColor,
          onTap: (int index) {
            setState(
              () {
                _selectedIndex = index;
              },
            );
          },
        ),
      ),
    );
  }
}
