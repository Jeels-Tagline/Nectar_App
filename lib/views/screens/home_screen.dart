// ignore_for_file: deprecated_member_use, unrelated_type_equality_checks, use_build_context_synchronously

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:nectar_app/main.dart';
import 'package:nectar_app/models/globals/boxes.dart';
import 'package:nectar_app/models/globals/globals.dart';
import 'package:nectar_app/models/hive_product_models.dart';
import 'package:nectar_app/models/product_models.dart';
import 'package:nectar_app/utils/font_family.dart';
import 'package:nectar_app/utils/images_path.dart';
import 'package:nectar_app/utils/screens_path.dart';
import 'package:nectar_app/utils/user_data.dart';
import 'package:nectar_app/utils/users_info.dart';
import 'package:nectar_app/views/components/common_check_user_connection.dart';
import 'package:nectar_app/views/components/common_offer_banner.dart';
import 'package:nectar_app/views/components/common_product.dart';
import 'package:nectar_app/views/screens/account_screen.dart';
import 'package:nectar_app/views/screens/cart_screen.dart';
import 'package:nectar_app/views/screens/explore_screen.dart';
import 'package:nectar_app/views/screens/favourite_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<HiveProductModel> listOfAllData = [];

  late List<HiveProductModel> fruitData = [];
  late List<HiveProductModel> vegetableData = [];
  late List<HiveProductModel> bakeryData = [];
  late List<HiveProductModel> pulsesData = [];
  late List<HiveProductModel> baverageData = [];
  late List<HiveProductModel> riceData = [];

  setAllData() {
    for (int i = 0; i < listOfAllData.length; i++) {
      if (listOfAllData[i].type == 'fruit') {
        fruitData.add(listOfAllData[i]);
      } else if (listOfAllData[i].type == 'vegetable') {
        vegetableData.add(listOfAllData[i]);
      } else if (listOfAllData[i].type == 'bakery') {
        bakeryData.add(listOfAllData[i]);
      } else if (listOfAllData[i].type == 'baverage') {
        baverageData.add(listOfAllData[i]);
      } else if (listOfAllData[i].type == 'pulses') {
        pulsesData.add(listOfAllData[i]);
      } else if (listOfAllData[i].type == 'rice') {
        riceData.add(listOfAllData[i]);
      }
    }
  }

  int _selectedIndex = 0;

  static const images = [
    ImagesPath.banner1,
    ImagesPath.banner2,
    ImagesPath.banner3,
  ];

  Future setUserData() async {
    UserData.uid = sharedPreferences!.getString(UsersInfo.userId) ?? '';
    UserData.displayName =
        sharedPreferences!.getString(UsersInfo.userDisplayName) ?? '';
    UserData.email = sharedPreferences!.getString(UsersInfo.userEmail) ?? '';
    UserData.city = sharedPreferences!.getString(UsersInfo.userCity) ?? '';
    UserData.location =
        sharedPreferences!.getString(UsersInfo.userLocation) ?? '';
    UserData.phoneNumber =
        sharedPreferences!.getString(UsersInfo.userPhoneNumber) ?? '';
    UserData.photo = sharedPreferences!.getString(UsersInfo.userPhoto) ?? '';
    setState(() {});
  }

  final CarouselController carouselController = CarouselController();
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    setUserData();
    listOfAllData =
        boxListOfProduct.get(0, defaultValue: [])?.cast<HiveProductModel>();
    setAllData();
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
                    child: GestureDetector(
                      onTap: () {
                        CommonCheckUserConnection();
                      },
                      child: SizedBox(
                        height: h * 0.04,
                        child: Image.asset(ImagesPath.carotOrange),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: h * 0.01),
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
                          name: "Fruit",
                        ),
                        SizedBox(
                          // width: w,
                          height: h * 0.29,
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: fruitData.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(
                                    top: h * 0.02, right: w * 0.025),
                                child: CommonProduct(
                                  userId: UserData.uid,
                                  productData: ProductModel(
                                    id: fruitData[index].id,
                                    name: fruitData[index].name,
                                    subTitle: fruitData[index].subTitle,
                                    price: fruitData[index].price,
                                    detail: fruitData[index].detail,
                                    nutrition: fruitData[index].nutrition,
                                    review: fruitData[index].review,
                                    type: fruitData[index].type,
                                    image1: fruitData[index].image1,
                                    image2: fruitData[index].image2,
                                    image3: fruitData[index].image3,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: h * 0.03),
                          child: const CommonOfferBanner(
                            offerName: "Best Selling",
                            name: "Baverage",
                          ),
                        ),
                        SizedBox(
                          // width: w,
                          height: h * 0.29,
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: baverageData.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(
                                    top: h * 0.02, right: w * 0.025),
                                child: CommonProduct(
                                  userId: UserData.uid,
                                  productData: ProductModel(
                                    id: baverageData[index].id,
                                    name: baverageData[index].name,
                                    subTitle: baverageData[index].subTitle,
                                    price: baverageData[index].price,
                                    detail: baverageData[index].detail,
                                    nutrition: baverageData[index].nutrition,
                                    review: baverageData[index].review,
                                    type: baverageData[index].type,
                                    image1: baverageData[index].image1,
                                    image2: baverageData[index].image2,
                                    image3: baverageData[index].image3,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: h * 0.03),
                          child: const CommonOfferBanner(
                            offerName: "Bakery",
                            name: "Bakery",
                          ),
                        ),
                        SizedBox(
                          // width: w,
                          height: h * 0.29,
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: bakeryData.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(
                                    top: h * 0.02, right: w * 0.025),
                                child: CommonProduct(
                                  userId: UserData.uid,
                                  productData: ProductModel(
                                    id: bakeryData[index].id,
                                    name: bakeryData[index].name,
                                    subTitle: bakeryData[index].subTitle,
                                    price: bakeryData[index].price,
                                    detail: bakeryData[index].detail,
                                    nutrition: bakeryData[index].nutrition,
                                    review: bakeryData[index].review,
                                    type: bakeryData[index].type,
                                    image1: bakeryData[index].image1,
                                    image2: bakeryData[index].image2,
                                    image3: bakeryData[index].image3,
                                  ),
                                ),
                              );
                            },
                          ),
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
                                          child: Image.asset(ImagesPath.pulses),
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
                                            child: Image.asset(ImagesPath.rice),
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
                        SizedBox(
                          // width: w,
                          height: h * 0.29,
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: vegetableData.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(
                                    top: h * 0.02, right: w * 0.025),
                                child: CommonProduct(
                                  userId: UserData.uid,
                                  productData: ProductModel(
                                    id: vegetableData[index].id,
                                    name: vegetableData[index].name,
                                    subTitle: vegetableData[index].subTitle,
                                    price: vegetableData[index].price,
                                    detail: vegetableData[index].detail,
                                    nutrition: vegetableData[index].nutrition,
                                    review: vegetableData[index].review,
                                    type: vegetableData[index].type,
                                    image1: vegetableData[index].image1,
                                    image2: vegetableData[index].image2,
                                    image3: vegetableData[index].image3,
                                  ),
                                ),
                              );
                            },
                          ),
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
      // height: 80,
      decoration: const BoxDecoration(
        // borderRadius: BorderRadius.only(
        //     topRight: Radius.circular(15), topLeft: Radius.circular(15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black38,
            spreadRadius: 0,
            blurRadius: 5,
          ),
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
