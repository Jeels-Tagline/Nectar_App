import 'package:flutter/material.dart';
import 'package:nectar_app/models/globals/globals.dart';
import 'package:nectar_app/utils/font_family.dart';
import 'package:nectar_app/views/components/common_action_button.dart';
import 'package:nectar_app/views/components/common_headline_text.dart';
import 'package:nectar_app/views/components/common_title_text.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  List<Map> filterCheckBox = [
    {"name": "Strawberry", "isChecked": false},
    {"name": "Kiwi", "isChecked": false},
    {"name": "Red Bull", "isChecked": false},
    {"name": "Waffle", "isChecked": false},
    {"name": "Bagel", "isChecked": false},
    {"name": "Kidney Beans", "isChecked": false},
    {"name": "Sushi Rice", "isChecked": false},
    {"name": "Basmati Rice", "isChecked": false},
  ];

  @override
  Widget build(BuildContext context) {
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
        title: const CommonHeadlineText(
          title: 'Filters',
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          height: h,
          width: w,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
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
                const CommonTitleText(title: "Categories"),
                SizedBox(
                  height: h * 0.02,
                ),
                ...filterCheckBox.map((e) {
                  return Transform.translate(
                    offset: Offset(-w * 0.025, 0),
                    child: Row(
                      children: [
                        Checkbox(
                          value: e["isChecked"],
                          onChanged: (value) {
                            setState(() {
                              e["isChecked"] = !e["isChecked"];
                            });
                          },
                        ),
                        Text(
                          e["name"],
                          style: TextStyle(
                            color: (e['isChecked'])
                                ? Globals.greenColor
                                : Colors.black,
                            fontSize: 16,
                            fontFamily: FontFamily.medium,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList()
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(left: w * 0.08),
        child: GestureDetector(
          onTap: () {
            List<String>? filter = [];

            List.generate(filterCheckBox.length, (index) {
              if (filterCheckBox[index]['isChecked']) {
                filter.add(filterCheckBox[index]['name']);
              }
            });

            if (filter.isEmpty) {
              Navigator.pop(context);
            } else {
              Navigator.pop(context, filter);
            }
          },
          child: const CommonActionButton(name: 'Apply'),
        ),
      ),
    );
  }
}
