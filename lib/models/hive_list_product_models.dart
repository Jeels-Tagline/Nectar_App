import 'package:hive/hive.dart';
import 'package:nectar_app/models/hive_product_models.dart';

part 'hive_list_product_models.g.dart';

@HiveType(typeId: 2)
class HiveListProductModel {
  @HiveField(0)
  List<HiveProductModel> listOfProduct = [];

  HiveListProductModel({
    required listOfProduct,
  });
}
