// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:nectar_app/models/globals/boxes.dart';
import 'package:nectar_app/models/globals/globals.dart';
import 'package:nectar_app/models/hive_product_models.dart';
import 'package:nectar_app/models/product_models.dart';
import 'package:nectar_app/utils/images_path.dart';
import 'package:nectar_app/utils/screens_path.dart';
import 'package:nectar_app/utils/user_data.dart';
import 'package:nectar_app/views/components/common_product.dart';
import 'package:nectar_app/views/components/common_textfield.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late List<HiveProductModel> listOfAllData = [];
  late List<HiveProductModel> searchList = [];
  late List<HiveProductModel> filterList = [];
  late List<HiveProductModel> filterShowList = [];
  TextEditingController searchController = TextEditingController();
  String? search;
  var filter;

  // String userId = "";
  // getUserId() async {
  //   userId = sharedPreferences!.getString(UsersInfo.userId) ?? '';

  //   setState(() {});
  // }

  refreshUI() {
    Future.delayed(const Duration(seconds: 0), () {
      setState(() {});
    });
  }

  searchData({required String search}) {
    if (filter != null) {
      filterShowList.clear();
      for (var e in filterList) {
        var name = e.name.toString().toLowerCase();
        if (name.contains(search.toLowerCase())) {
          filterShowList.add(e);
        }
      }
      print("============ Filter Data");
    } else {
      print("============ All Data");
      for (var e in listOfAllData) {
        var name = e.name.toString().toLowerCase();
        if (name.contains(search.toLowerCase())) {
          searchList.add(e);
        }
      }
    }
  }

  filterData({required List<String> filter}) {
    for (int i = 0; i < filter.length; i++) {
      for (var e in listOfAllData) {
        var type = e.type.toString().toLowerCase();
        if (type.contains(filter[i].toLowerCase())) {
          filterList.add(e);
          filterShowList.add(e);
        }
      }
    }
  }

  setSearchList() {
    for (int i = 0; i < listOfAllData.length; i++) {
      searchList.add(listOfAllData[i]);
    }
  }

  @override
  void initState() {
    super.initState();
    // getUserId();
    listOfAllData =
        boxListOfProduct.get(0, defaultValue: [])?.cast<HiveProductModel>();

    setSearchList();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.only(
            top: h * 0.04, bottom: h * 0.02, left: w * 0.04, right: w * 0.04),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: h * 0.04),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: h * 0.055,
                      width: w * 0.84,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Icon(
                              Icons.search,
                              size: 30,
                            ),
                          ),
                          Expanded(
                            flex: 6,
                            child: CommonTextFormField(
                              controller: searchController,
                              onChange: (val) {
                                setState(() {
                                  search = val;
                                });

                                if (search == "") {
                                  if (filter != null) {
                                    filterList.clear();
                                    filterShowList.clear();
                                    filterData(filter: filter);
                                  } else {
                                    searchList.clear();
                                    setSearchList();
                                  }
                                } else {
                                  searchList.clear();
                                  searchData(search: search!);
                                }
                                return null;
                              },
                              hineText: "Search Store",
                              inputBorder: InputBorder.none,
                            ),
                          ),
                          (search != null)
                              ? (filter != null)
                                  ? Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            search = null;
                                            searchController.clear();
                                            filterList.clear();
                                            filterShowList.clear();
                                            filterData(filter: filter);
                                          });
                                        },
                                        child: const Icon(
                                          Icons.cancel,
                                          size: 22,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    )
                                  : Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            search = null;
                                            searchController.clear();
                                            searchList.clear();
                                            setSearchList();
                                          });
                                        },
                                        child: const Icon(
                                          Icons.cancel,
                                          size: 22,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    )
                              : Container(),
                        ],
                      ),
                    ),
                    if (filter == null)
                      GestureDetector(
                        onTap: () async {
                          search = null;
                          searchController.clear();

                          filter = await Navigator.pushNamed(
                                  context, ScreensPath.filterScreen)
                              as List<String>?;

                          if (filter != null) {
                            filterList.clear();
                            filterData(filter: filter);
                            setState(() {});
                          }
                        },
                        child: Image.asset(ImagesPath.filter),
                      )
                    else
                      GestureDetector(
                        onTap: () async {
                          filter = null;
                          searchList.clear();
                          setSearchList();
                          filterShowList.clear();
                          filterList.clear();
                          setState(() {});
                        },
                        child: Icon(
                          Icons.cancel,
                          size: 28,
                          color: Globals.greenColor,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            (filter != null)
                ? Expanded(
                    flex: 8,
                    child: GridView.count(
                      shrinkWrap: true,
                      childAspectRatio: ((w / 2) / (h / 3.33)),
                      crossAxisCount: 2,
                      mainAxisSpacing: w * 0.02,
                      crossAxisSpacing: h * 0.02,
                      children: List.generate(
                        filterShowList.length,
                        (index) => CommonProduct(
                          userId: UserData.uid,
                          productData: ProductModel(
                            id: filterShowList[index].id,
                            name: filterShowList[index].name,
                            subTitle: filterShowList[index].subTitle,
                            price: filterShowList[index].price,
                            detail: filterShowList[index].detail,
                            nutrition: filterShowList[index].nutrition,
                            review: filterShowList[index].review,
                            type: filterShowList[index].type,
                            image1: filterShowList[index].image1,
                            image2: filterShowList[index].image2,
                            image3: filterShowList[index].image3,
                          ),
                        ),
                      ),
                    ),
                  )
                : Expanded(
                    flex: 8,
                    child: GridView.count(
                      shrinkWrap: true,
                      childAspectRatio: ((w / 2) / (h / 3.33)),
                      crossAxisCount: 2,
                      mainAxisSpacing: w * 0.02,
                      crossAxisSpacing: h * 0.02,
                      children: List.generate(
                        searchList.length,
                        (index) => CommonProduct(
                          userId: UserData.uid,
                          productData: ProductModel(
                            id: searchList[index].id,
                            name: searchList[index].name,
                            subTitle: searchList[index].subTitle,
                            price: searchList[index].price,
                            detail: searchList[index].detail,
                            nutrition: searchList[index].nutrition,
                            review: searchList[index].review,
                            type: searchList[index].type,
                            image1: searchList[index].image1,
                            image2: searchList[index].image2,
                            image3: searchList[index].image3,
                          ),
                        ),
                      ),
                    ),
                    //     FutureBuilder(
                    //   future: FirestoreHelper.firestoreHelper.getSearchProductData(
                    //     search: search ?? '',
                    //     filter: filter ?? [],
                    //   ),
                    //   builder: (context, snapShot) {
                    //     if (snapShot.hasError) {
                    //       return Text("${snapShot.error}");
                    //     } else if (snapShot.hasData) {
                    //       List<ProductModel>? productData = snapShot.data;
                    //       // List<QueryDocumentSnapshot<Map<String, dynamic>>>
                    //       //     productData = product!.docs;
                    //       //   return GridView.count(
                    //       //     shrinkWrap: true,
                    //       //     childAspectRatio: ((w / 2) / (h / 3.37)),
                    //       //     physics: const NeverScrollableScrollPhysics(),
                    //       //     crossAxisCount: 2,
                    //       //     mainAxisSpacing: w * 0.02,
                    //       //     crossAxisSpacing: h * 0.02,
                    //       //     children: List.generate(
                    //       //       productData.length,
                    //       //       (index) => CommonProduct(
                    //       //         userId: userId,
                    //       //         productData: ProductModel(
                    //       //           id: productData[index].data()['id'],
                    //       //           name: productData[index].data()['name'],
                    //       //           subTitle: productData[index].data()['subTitle'],
                    //       //           price: double.parse(
                    //       //               productData[index].data()['price']),
                    //       //           detail: productData[index].data()['detail'],
                    //       //           nutrition: productData[index].data()['nutrition'],
                    //       //           review: int.parse(
                    //       //               productData[index].data()['review']),
                    //       //           type: productData[index].data()['type'],
                    //       //           image1: productData[index].data()['image1'],
                    //       //           image2: productData[index].data()['image2'],
                    //       //           image3: productData[index].data()['image3'],
                    //       //         ),
                    //       //       ),
                    //       //     ),
                    //       //   );
                    //       // }
                    //       return GridView.count(
                    //         shrinkWrap: true,
                    //         childAspectRatio: ((w / 2) / (h / 3.33)),
                    //         crossAxisCount: 2,
                    //         mainAxisSpacing: w * 0.02,
                    //         crossAxisSpacing: h * 0.02,
                    //         children: List.generate(
                    //           productData!.length,
                    //           (index) => CommonProduct(
                    //             userId: userId,
                    //             productData: ProductModel(
                    //               id: productData[index].id,
                    //               name: productData[index].name,
                    //               subTitle: productData[index].subTitle,
                    //               price: productData[index].price,
                    //               detail: productData[index].detail,
                    //               nutrition: productData[index].nutrition,
                    //               review: productData[index].review,
                    //               type: productData[index].type,
                    //               image1: productData[index].image1,
                    //               image2: productData[index].image2,
                    //               image3: productData[index].image3,
                    //             ),
                    //           ),
                    //         ),
                    //       );
                    //     }
                    //     return Shimmer.fromColors(
                    //       baseColor: Colors.grey[300]!,
                    //       highlightColor: Colors.grey[100]!,
                    //       child: GridView.count(
                    //         shrinkWrap: true,
                    //         childAspectRatio: ((w / 2) / (h / 3.33)),
                    //         physics: const NeverScrollableScrollPhysics(),
                    //         crossAxisCount: 2,
                    //         mainAxisSpacing: w * 0.02,
                    //         crossAxisSpacing: h * 0.02,
                    //         children: List.generate(
                    //           4,
                    //           (index) => Container(
                    //             width: w * 0.4,
                    //             padding: EdgeInsets.only(
                    //               top: h * 0.01,
                    //               bottom: h * 0.01,
                    //               left: w * 0.01,
                    //               right: w * 0.01,
                    //             ),
                    //             decoration: BoxDecoration(
                    //               border: Border.all(color: Colors.grey.shade400),
                    //               borderRadius: BorderRadius.circular(15),
                    //             ),
                    //             child: Padding(
                    //               padding: const EdgeInsets.all(8.0),
                    //               child: Column(
                    //                 crossAxisAlignment: CrossAxisAlignment.start,
                    //                 children: [
                    //                   Container(
                    //                     height: h * 0.1,
                    //                     width: w,
                    //                     decoration: BoxDecoration(
                    //                       color: Colors.red,
                    //                       borderRadius: BorderRadius.circular(8),
                    //                     ),
                    //                   ),
                    //                   Padding(
                    //                     padding: EdgeInsets.only(top: h * 00.01),
                    //                     child: Container(
                    //                       height: h * 0.02,
                    //                       width: w,
                    //                       decoration: BoxDecoration(
                    //                         color: Colors.red,
                    //                         borderRadius: BorderRadius.circular(5),
                    //                       ),
                    //                     ),
                    //                   ),
                    //                   Padding(
                    //                     padding: EdgeInsets.only(top: h * 00.01),
                    //                     child: Container(
                    //                       height: h * 0.01,
                    //                       width: w,
                    //                       decoration: BoxDecoration(
                    //                         color: Colors.red,
                    //                         borderRadius: BorderRadius.circular(5),
                    //                       ),
                    //                     ),
                    //                   ),
                    //                   Padding(
                    //                     padding: EdgeInsets.only(top: h * 0.013),
                    //                     child: Row(
                    //                       mainAxisAlignment:
                    //                           MainAxisAlignment.spaceBetween,
                    //                       children: [
                    //                         Container(
                    //                           height: h * 0.03,
                    //                           width: w * 0.15,
                    //                           decoration: BoxDecoration(
                    //                             color: Colors.red,
                    //                             borderRadius:
                    //                                 BorderRadius.circular(7),
                    //                           ),
                    //                         ),
                    //                         Container(
                    //                           height: h * 0.055,
                    //                           width: w * 0.12,
                    //                           alignment: Alignment.center,
                    //                           decoration: BoxDecoration(
                    //                             color: Colors.red,
                    //                             borderRadius:
                    //                                 BorderRadius.circular(15),
                    //                           ),
                    //                         ),
                    //                       ],
                    //                     ),
                    //                   )
                    //                 ],
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     );
                    //   },
                    // ),
                  ),
          ],
        ),
      ),
    );
  }
}
