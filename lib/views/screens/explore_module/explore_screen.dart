import 'package:flutter/material.dart';
import 'package:nectar_app/navigator.dart';
import 'package:nectar_app/utils/images_path.dart';
import 'package:nectar_app/utils/screens_path.dart';
import 'package:nectar_app/views/components/common_headline_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  List productList = [];
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      productList = [
        {
          'color': Colors.green,
          'backgroundColor': Colors.green.shade50,
          'name': 'Fruit',
          'image': ImagesPath.fruit,
          'showTitle':
              AppLocalizations.of(NavKey.navKey.currentContext!)!.fruit,
        },
        {
          'color': Colors.orange,
          'backgroundColor': Colors.orange.shade50,
          'name': 'Vegetable',
          'image': ImagesPath.vegetable,
          'showTitle':
              AppLocalizations.of(NavKey.navKey.currentContext!)!.vegetable,
        },
        {
          'color': Colors.red,
          'backgroundColor': Colors.red.shade50,
          'name': 'Bakery',
          'image': ImagesPath.bakery,
          'showTitle':
              AppLocalizations.of(NavKey.navKey.currentContext!)!.bakery,
        },
        {
          'color': Colors.purple,
          'backgroundColor': Colors.purple.shade50,
          'name': 'Baverage',
          'image': ImagesPath.baverage,
          'showTitle': AppLocalizations.of(context)!.baverage,
        },
        {
          'color': Colors.brown,
          'backgroundColor': Colors.brown.shade50,
          'name': 'Pulses',
          'image': ImagesPath.pulses,
          'showTitle':
              AppLocalizations.of(NavKey.navKey.currentContext!)!.pulses,
        },
        {
          'color': Colors.blue,
          'backgroundColor': Colors.blue.shade50,
          'name': 'Rice',
          'image': ImagesPath.rice,
          'showTitle':
              AppLocalizations.of(NavKey.navKey.currentContext!)!.rices,
        },
      ];
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.only(
              top: h * 0.07, bottom: h * 0.02, left: w * 0.04, right: w * 0.04),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: CommonHeadlineText(
                    title: AppLocalizations.of(context)!.findProducts),
              ),
              Padding(
                padding: EdgeInsets.only(top: h * 0.04),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, ScreensPath.searchScreen);
                  },
                  child: Container(
                    height: 45,
                    width: w,
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
                          child: Text(
                            AppLocalizations.of(context)!.searchStore,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Transform.translate(
                offset: Offset(0, -h * 0.025),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: w * 0.02,
                  crossAxisSpacing: h * 0.02,
                  children: List.generate(
                    productList.length,
                    (index) => GestureDetector(
                      onTap: () {
                        Map<String, dynamic> data = {
                          'name': productList[index]['name'],
                          'showTitle': productList[index]['showTitle'],
                        };
                        Navigator.pushNamed(
                          context,
                          ScreensPath.exploreProductScreen,
                          arguments: data,
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: productList[index]['backgroundColor'],
                          border:
                              Border.all(color: productList[index]['color']),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              SizedBox(
                                height: h * 0.14,
                                // width: w * 0.35,
                                child: Image.asset(
                                    "${productList[index]['image']}"),
                              ),
                              Text(
                                "${productList[index]['showTitle']}",
                                style: const TextStyle(fontSize: 20),
                              )
                            ],
                          ),
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
