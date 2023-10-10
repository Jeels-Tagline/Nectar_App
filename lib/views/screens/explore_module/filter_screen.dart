import 'package:flutter/material.dart';
import 'package:nectar_app/models/globals/globals.dart';
import 'package:nectar_app/utils/font_family.dart';
import 'package:nectar_app/views/components/common_action_button.dart';
import 'package:nectar_app/views/components/common_headline_text.dart';
import 'package:nectar_app/views/components/common_title_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  List<Map> filterCheckBox = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      filterCheckBox = [
        {
          "type": "Fruit",
          "isChecked": false,
          'show': AppLocalizations.of(context)!.fruit,
        },
        {
          "type": "Vegetable",
          "isChecked": false,
          'show': AppLocalizations.of(context)!.vegetable,
        },
        {
          "type": "Bakery",
          "isChecked": false,
          'show': AppLocalizations.of(context)!.bakery,
        },
        {
          "type": "Baverage",
          "isChecked": false,
          'show': AppLocalizations.of(context)!.baverage,
        },
        {
          "type": "Pulses",
          "isChecked": false,
          'show': AppLocalizations.of(context)!.pulses,
        },
        {
          "type": "Rice",
          "isChecked": false,
          'show': AppLocalizations.of(context)!.rices,
        },
      ];
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // List showLanguageWise = [];

    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.close),
        ),
        title: CommonHeadlineText(
          title: AppLocalizations.of(context)!.filters,
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Container(
              height: h,
              width: w,
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(30)),
                color: Colors.grey.shade200,
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  top: h * 0.03,
                  bottom: 0.03,
                  left: w * 0.05,
                  right: w * 0.05,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonTitleText(
                      title: AppLocalizations.of(context)!.categories,
                    ),
                    SizedBox(
                      height: h * 0.02,
                    ),
                    ...List.generate(filterCheckBox.length, (index) {
                      return Transform.translate(
                        offset: Offset(-w * 0.025, 0),
                        child: Row(
                          children: [
                            Checkbox(
                              value: filterCheckBox[index]["isChecked"],
                              onChanged: (value) {
                                setState(() {
                                  filterCheckBox[index]["isChecked"] =
                                      !filterCheckBox[index]["isChecked"];
                                });
                              },
                            ),
                            Text(
                              filterCheckBox[index]["show"],
                              style: TextStyle(
                                color: (filterCheckBox[index]['isChecked'])
                                    ? Globals.greenColor
                                    : Colors.black,
                                fontSize: 16,
                                fontFamily: FontFamily.medium,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(
                  left: w * 0.04, right: w * 0.04, bottom: h * 0.03),
              child: GestureDetector(
                onTap: () {
                  List<String>? filter = [];

                  List.generate(filterCheckBox.length, (index) {
                    if (filterCheckBox[index]['isChecked']) {
                      filter.add(filterCheckBox[index]['type']);
                    }
                  });

                  if (filter.isEmpty) {
                    Navigator.pop(context);
                  } else {
                    Navigator.pop(context, filter);
                  }
                },
                child: CommonActionButton(
                  name: AppLocalizations.of(context)!.apply,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
