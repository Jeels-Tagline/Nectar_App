class ProductModel {
  String id;
  String name;
  String subTitle;
  double price;
  String detail;
  String nutrition;
  int review;
  String type;
  String image1;
  String image2;
  String image3;
  int? quantity;
  bool? favourite;

  ProductModel({
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
  });

  factory ProductModel.fromMap({required Map<String, dynamic> data}) {
    return ProductModel(
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
      quantity: data['quantity'],
      favourite: data['favourite'],
    );
  }
}
