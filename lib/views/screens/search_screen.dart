import 'package:flutter/material.dart';
import 'package:nectar_app/views/components/common_textfield.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.only(
              top: h * 0.04, bottom: h * 0.02, left: w * 0.04, right: w * 0.04),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
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
                          const Expanded(
                            flex: 6,
                            child: CommonTextFormField(
                              hineText: "Search Store",
                              inputBorder: InputBorder.none,
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {},
                              child: const Icon(
                                Icons.cancel,
                                size: 22,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Image.asset("assets/icons/filter.png"),
                  ],
                ),
              ),
              // Transform.translate(
              //   offset: Offset(0, -h * 0.025),
              //   child: GridView.count(
              //     shrinkWrap: true,
              //     physics: const NeverScrollableScrollPhysics(),
              //     crossAxisCount: 2,
              //     mainAxisSpacing: w * 0.02,
              //     crossAxisSpacing: h * 0.02,
              //     children: List.generate(
              //       productList.length,
              //       (index) => GestureDetector(
              //         onTap: () {
              //           Navigator.pushNamed(context, 'explore_product_screen',
              //               arguments: productList[index]['name']);
              //         },
              //         child: Container(
              //           decoration: BoxDecoration(
              //             color: productList[index]['backgroundColor'],
              //             border:
              //                 Border.all(color: productList[index]['color']),
              //             borderRadius: BorderRadius.circular(18),
              //           ),
              //           child: Padding(
              //             padding: const EdgeInsets.all(8.0),
              //             child: Column(
              //               children: [
              //                 SizedBox(
              //                   height: h * 0.15,
              //                   width: w * 0.35,
              //                   child: Image.asset(
              //                       "${productList[index]['image']}"),
              //                 ),
              //                 Text(
              //                   "${productList[index]['name']}",
              //                   style: const TextStyle(fontSize: 20),
              //                 )
              //               ],
              //             ),
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
