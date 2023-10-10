import 'package:hive/hive.dart';

part 'hive_product_models.g.dart';

@HiveType(typeId: 1)
class HiveProductModel {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String subTitle;

  @HiveField(3)
  double price;

  @HiveField(4)
  String detail;

  @HiveField(5)
  String nutrition;

  @HiveField(6)
  int review;

  @HiveField(7)
  String type;

  @HiveField(8)
  String image1;

  @HiveField(9)
  String image2;

  @HiveField(10)
  String image3;

  @HiveField(11)
  int? quantity;

  @HiveField(12)
  bool? favourite;

  @HiveField(13)
  int bestSelling;

  @HiveField(14)
  int exclusiveOffer;

  HiveProductModel({
    required this.id,
    required this.name,
    required this.subTitle,
    required this.price,
    required this.detail,
    required this.nutrition,
    required this.review,
    required this.type,
    required this.image1,
    required this.image2,
    required this.image3,
    this.quantity,
    this.favourite,
    required this.bestSelling,
    required this.exclusiveOffer,
  });

  factory HiveProductModel.fromMap({required Map<String, dynamic> data}) {
    return HiveProductModel(
      id: data['id'],
      name: data['name'],
      subTitle: data['subTitle'],
      price: data['price'],
      detail: data['detail'],
      nutrition: data['nutrition'],
      review: data['review'],
      type: data['type'],
      image1: data['image1'],
      image2: data['image2'],
      image3: data['image3'],
      quantity: data['quantity'] ?? 1,
      favourite: data['favourite'] ?? false,
      bestSelling: data['bestSelling'],
      exclusiveOffer: data['exclusiveOffer'],
    );
  }
}
