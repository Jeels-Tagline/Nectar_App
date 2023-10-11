// ignore_for_file: deprecated_member_use, unrelated_type_equality_checks, use_build_context_synchronously, unused_element

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:nectar_app/models/globals/globals.dart';
import 'package:nectar_app/models/hive_product_models.dart';
import 'package:nectar_app/models/product_models.dart';
import 'package:nectar_app/utils/font_family.dart';
import 'package:nectar_app/utils/images_path.dart';
import 'package:nectar_app/utils/screens_path.dart';
import 'package:nectar_app/utils/user_data.dart';
import 'package:nectar_app/views/components/common_offer_banner.dart';
import 'package:nectar_app/views/components/common_product.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // late List<HiveProductModel> listOfAllData = [];
  // late List<HiveProductModel> fruitData = [];
  // late List<HiveProductModel> vegetableData = [];
  // late List<HiveProductModel> bakeryData = [];
  // late List<HiveProductModel> pulsesData = [];
  // late List<HiveProductModel> baverageData = [];
  // late List<HiveProductModel> riceData = [];
  // setAllData() {
  //   for (int i = 0; i < listOfAllData.length; i++) {
  //     if (listOfAllData[i].type == 'fruit') {
  //       fruitData.add(listOfAllData[i]);
  //     } else if (listOfAllData[i].type == 'vegetable') {
  //       vegetableData.add(listOfAllData[i]);
  //     } else if (listOfAllData[i].type == 'bakery') {
  //       bakeryData.add(listOfAllData[i]);
  //     } else if (listOfAllData[i].type == 'baverage') {
  //       baverageData.add(listOfAllData[i]);
  //     } else if (listOfAllData[i].type == 'pulses') {
  //       pulsesData.add(listOfAllData[i]);
  //     } else if (listOfAllData[i].type == 'rice') {
  //       riceData.add(listOfAllData[i]);
  //     }
  //   }
  // }

  static const images = [
    ImagesPath.banner1,
    ImagesPath.banner2,
    ImagesPath.banner3,
  ];

  List<HiveProductModel> bestSellingList = [];
  List<HiveProductModel> exclusiveOfferList = [];

  // Future setUserData() async {
  //   UserData.uid = sharedPreferences!.getString(UsersInfo.userId) ?? '';
  //   UserData.displayName =
  //       sharedPreferences!.getString(UsersInfo.userDisplayName) ?? '';
  //   UserData.email = sharedPreferences!.getString(UsersInfo.userEmail) ?? '';
  //   UserData.city = sharedPreferences!.getString(UsersInfo.userCity) ?? '';
  //   UserData.location =
  //       sharedPreferences!.getString(UsersInfo.userLocation) ?? '';
  //   UserData.phoneNumber =
  //       sharedPreferences!.getString(UsersInfo.userPhoneNumber) ?? '';
  //   UserData.photo = sharedPreferences!.getString(UsersInfo.userPhoto) ?? '';
  //   setState(() {});
  // }

  final CarouselController carouselController = CarouselController();
  int currentIndex = 0;

  setBestSelling() {
    for (int i = 5; i > 0; i--) {
      for (int j = 0; j < Globals.allProduct.length; j++) {
        if (i == Globals.allProduct[j].bestSelling) {
          bestSellingList.add(Globals.allProduct[j]);
        }
      }
    }
  }

  setExclusiveOffer() {
    // list = Globals.allProduct;
    // HiveProductModel temp;
    // for (int i = 0; i < list.length - 1; i++) {
    //   for (int j = i + 1; j < list.length; j++) {
    //     if (list[i].exclusiveOffer > list[j].exclusiveOffer) {
    //       temp = list[j];
    //       list[j] = list[i];
    //       list[i] = temp;
    //     }
    //   }
    // }

    HiveProductModel temp;
    for (int i = 0; i < Globals.allProduct.length; i++) {
      exclusiveOfferList.add(Globals.allProduct[i]);
    }
    for (int i = 0; i < exclusiveOfferList.length - 1; i++) {
      for (int j = i + 1; j < exclusiveOfferList.length; j++) {
        if (exclusiveOfferList[i].exclusiveOffer <
            exclusiveOfferList[j].exclusiveOffer) {
          temp = exclusiveOfferList[i];
          exclusiveOfferList[i] = exclusiveOfferList[j];
          exclusiveOfferList[j] = temp;
        }
      }
    }
    // exclusiveOfferList = list.reversed;
  }

  @override
  void initState() {
    super.initState();
    UserData.setUserData();
    Globals.setAllData();
    setBestSelling();
    setExclusiveOffer();
    // listOfAllData = Globals.boxListOfProduct
    //     .get(0, defaultValue: [])?.cast<HiveProductModel>();
    // setAllData();
  }

  @override
  Widget build(BuildContext context) {
    // title(String val) {
    //   switch (val) {
    //     case 'en':
    //       return const Text(
    //         'English',
    //         style: TextStyle(fontSize: 16.0),
    //       );
    //     case 'gu':
    //       return const Text(
    //         'Gujarati',
    //         style: TextStyle(fontSize: 16.0),
    //       );
    //     case 'ur':
    //       return const Text(
    //         'Urdu',
    //         style: TextStyle(fontSize: 16.0),
    //       );
    //     default:
    //       return const Text(
    //         'English',
    //         style: TextStyle(fontSize: 16.0),
    //       );
    //   }
    // }

    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: h * 0.06),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: SizedBox(
                  height: 35,
                  child: Image.asset(ImagesPath.carotOrange),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: FittedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.location_on, color: Colors.grey.shade800),
                      Text(
                        UserData.city,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: StatefulBuilder(builder: (context, setStateJ) {
                  return Stack(
                    children: [
                      SizedBox(
                        height: 110,
                        width: double.infinity,
                        child: CarouselSlider.builder(
                          itemCount: images.length,
                          itemBuilder: (BuildContext context, int itemIndex,
                                  int pageViewIndex) =>
                              Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                  image: AssetImage(images[itemIndex]),
                                  fit: BoxFit.cover),
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
                        top: 90,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: images.asMap().entries.map((e) {
                            return GestureDetector(
                              onTap: () =>
                                  carouselController.animateToPage(e.key),
                              child: Container(
                                width: (currentIndex == e.key) ? 18 : 6,
                                height: 6,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 3),
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
                padding: const EdgeInsets.only(
                  top: 16,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CommonOfferBanner(
                      offerName: AppLocalizations.of(context)!.exclusiveOffer,

                      onTap: () {
                        Map<String, dynamic> data = {
                          'list': exclusiveOfferList,
                          'showTitle':
                              AppLocalizations.of(context)!.exclusiveOffer,
                        };
                        Navigator.pushNamed(
                          context,
                          ScreensPath.exploreProductScreen,
                          arguments: data,
                        );
                      },
                      // name: 'fruit',
                    ),
                    SizedBox(
                      height: 250,
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: exclusiveOfferList.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: (index == 0)
                                ? const EdgeInsets.only(
                                    top: 16,
                                    right: 10,
                                    left: 16,
                                  )
                                : const EdgeInsets.only(
                                    top: 16,
                                    right: 10,
                                  ),
                            child: CommonProduct(
                              userId: UserData.uid,
                              productData: ProductModel(
                                id: exclusiveOfferList[index].id,
                                name: exclusiveOfferList[index].name,
                                subTitle: exclusiveOfferList[index].subTitle,
                                price: exclusiveOfferList[index].price,
                                detail: exclusiveOfferList[index].detail,
                                nutrition: exclusiveOfferList[index].nutrition,
                                review: exclusiveOfferList[index].review,
                                type: exclusiveOfferList[index].type,
                                image1: exclusiveOfferList[index].image1,
                                image2: exclusiveOfferList[index].image2,
                                image3: exclusiveOfferList[index].image3,
                                exclusiveOffer:
                                    exclusiveOfferList[index].exclusiveOffer,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 22),
                      child: CommonOfferBanner(
                        offerName: AppLocalizations.of(context)!.bestSelling,
                        onTap: () {
                          Map<String, dynamic> data = {
                            'list': bestSellingList,
                            'showTitle':
                                AppLocalizations.of(context)!.bestSelling,
                          };
                          Navigator.pushNamed(
                            context,
                            ScreensPath.exploreProductScreen,
                            arguments: data,
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 250,
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: bestSellingList.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: (index == 0)
                                ? const EdgeInsets.only(
                                    top: 16,
                                    right: 10,
                                    left: 16,
                                  )
                                : const EdgeInsets.only(
                                    top: 16,
                                    right: 10,
                                  ),
                            child: CommonProduct(
                              userId: UserData.uid,
                              productData: ProductModel(
                                id: bestSellingList[index].id,
                                name: bestSellingList[index].name,
                                subTitle: bestSellingList[index].subTitle,
                                price: bestSellingList[index].price,
                                detail: bestSellingList[index].detail,
                                nutrition: bestSellingList[index].nutrition,
                                review: bestSellingList[index].review,
                                type: bestSellingList[index].type,
                                image1: bestSellingList[index].image1,
                                image2: bestSellingList[index].image2,
                                image3: bestSellingList[index].image3,
                                exclusiveOffer:
                                    bestSellingList[index].exclusiveOffer,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    // Padding(
                    //   padding: EdgeInsets.only(top: h * 0.03),
                    //   child: CommonOfferBanner(
                    //     offerName: AppLocalizations.of(context)!.bakery,
                    //     name: "Bakery",
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: h * 0.29,
                    //   child: ListView.builder(
                    //     physics: const BouncingScrollPhysics(),
                    //     scrollDirection: Axis.horizontal,
                    //     shrinkWrap: true,
                    //     itemCount: bakeryData.length,
                    //     itemBuilder: (context, index) {
                    //       return Padding(
                    //         padding: (index == 0)
                    //             ? EdgeInsets.only(
                    //                 top: h * 0.02,
                    //                 right: w * 0.025,
                    //                 left: w * 0.05,
                    //               )
                    //             : EdgeInsets.only(
                    //                 top: h * 0.02,
                    //                 right: w * 0.025,
                    //               ),
                    //         child: CommonProduct(
                    //           userId: UserData.uid,
                    //           productData: ProductModel(
                    //             id: bakeryData[index].id,
                    //             name: bakeryData[index].name,
                    //             subTitle: bakeryData[index].subTitle,
                    //             price: bakeryData[index].price,
                    //             detail: bakeryData[index].detail,
                    //             nutrition: bakeryData[index].nutrition,
                    //             review: bakeryData[index].review,
                    //             type: bakeryData[index].type,
                    //             image1: bakeryData[index].image1,
                    //             image2: bakeryData[index].image2,
                    //             image3: bakeryData[index].image3,
                    //           ),
                    //         ),
                    //       );
                    //     },
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.only(top: 24, bottom: 10),
                      child: CommonOfferBanner(
                        offerName: AppLocalizations.of(context)!.groceries,
                        onTap: () {
                          Navigator.pushNamed(
                              context, ScreensPath.exploreScreen);
                        },
                      ),
                    ),
                    SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Map<String, dynamic> data = {
                                'name': 'Pulses',
                                'showTitle':
                                    AppLocalizations.of(context)!.pulses,
                              };
                              Navigator.pushNamed(
                                context,
                                ScreensPath.exploreProductScreen,
                                arguments: data,
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: Container(
                                height: 90,
                                width: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color:
                                      const Color.fromARGB(255, 255, 224, 188),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12, right: 12),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Expanded(
                                        child: Image.asset(ImagesPath.pulses),
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          AppLocalizations.of(context)!.pulses,
                                          style: const TextStyle(
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
                          Padding(
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            child: GestureDetector(
                              onTap: () {
                                Map<String, dynamic> data = {
                                  'name': 'Rice',
                                  'showTitle':
                                      AppLocalizations.of(context)!.rices,
                                };
                                Navigator.pushNamed(
                                  context,
                                  ScreensPath.exploreProductScreen,
                                  arguments: data,
                                );
                              },
                              child: Container(
                                height: 90,
                                width: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: const Color(0xffe5f4ea),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12, right: 12),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Expanded(
                                        child: Image.asset(ImagesPath.rice),
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          AppLocalizations.of(context)!.rices,
                                          style: const TextStyle(
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
                    SizedBox(
                      height: 250,
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: Globals.allPulses.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: (index == 0)
                                ? const EdgeInsets.only(
                                    top: 16,
                                    right: 10,
                                    left: 16,
                                  )
                                : const EdgeInsets.only(
                                    top: 16,
                                    right: 10,
                                  ),
                            child: CommonProduct(
                              userId: UserData.uid,
                              productData: ProductModel(
                                id: Globals.allPulses[index].id,
                                name: Globals.allPulses[index].name,
                                subTitle: Globals.allPulses[index].subTitle,
                                price: Globals.allPulses[index].price,
                                detail: Globals.allPulses[index].detail,
                                nutrition: Globals.allPulses[index].nutrition,
                                review: Globals.allPulses[index].review,
                                type: Globals.allPulses[index].type,
                                image1: Globals.allPulses[index].image1,
                                image2: Globals.allPulses[index].image2,
                                image3: Globals.allPulses[index].image3,
                                exclusiveOffer:
                                    Globals.allPulses[index].exclusiveOffer,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
