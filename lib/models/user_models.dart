class UserModel {
  String uid;
  String email;
  String phoneNumber;
  String displayName;
  String location;
  List cart;
  List favourite;

  UserModel({
    required this.uid,
    required this.email,
    required this.phoneNumber,
    required this.displayName,
    required this.location,
    required this.cart,
    required this.favourite,
  });

  factory UserModel.fromMap({required Map data}) {
    return UserModel(
      uid: data['uid'],
      email: data['email'],
      phoneNumber: data['phoneNumber'],
      displayName: data['displayName'],
      location: data['location'],
      cart: data['cart'],
      favourite: data['favourite'],
    );
  }
}
