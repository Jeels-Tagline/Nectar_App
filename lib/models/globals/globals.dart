import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:nectar_app/models/hive_product_models.dart';

class Globals {
  static Color greenColor = const Color(0xff53B175);
  static late Box boxListOfProduct;
  static late Box<List<Map<String, dynamic>>> boxCart;

  static List<HiveProductModel> allProduct = Globals.boxListOfProduct
      .get(0, defaultValue: [])?.cast<HiveProductModel>();
  static List<HiveProductModel> allFruit = [];
  static List<HiveProductModel> allVegetable = [];
  static List<HiveProductModel> allBakery = [];
  static List<HiveProductModel> allPulses = [];
  static List<HiveProductModel> allBaverage = [];
  static List<HiveProductModel> allRice = [];

  static setAllData() {
    allFruit.clear();
    allVegetable.clear();
    allBakery.clear();
    allPulses.clear();
    allBaverage.clear();
    allRice.clear();
    for (int i = 0; i < allProduct.length; i++) {
      if (allProduct[i].type == 'fruit') {
        allFruit.add(allProduct[i]);
      } else if (allProduct[i].type == 'vegetable') {
        allVegetable.add(allProduct[i]);
      } else if (allProduct[i].type == 'bakery') {
        allBakery.add(allProduct[i]);
      } else if (allProduct[i].type == 'baverage') {
        allBaverage.add(allProduct[i]);
      } else if (allProduct[i].type == 'pulses') {
        allPulses.add(allProduct[i]);
      } else if (allProduct[i].type == 'rice') {
        allRice.add(allProduct[i]);
      }
    }
  }
}
