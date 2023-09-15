import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreHelper {
  FirestoreHelper._();

  static final FirestoreHelper firestoreHelper = FirestoreHelper._();

  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> insertUsers({required Map<String, dynamic> data}) async {
    await db.collection("tbl_users").doc("${data['uid']}").set(data);
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchUsers() async {
    return await db.collection("tbl_users").get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getUserData(
      {required String uid}) async {
    QuerySnapshot<Map<String, dynamic>> userData;

    userData =
        await db.collection("tbl_users").where('uid', isEqualTo: uid).get();

    return userData;
  }

  Future<void> insertCartData({
    required String uid,
    required Map<String, dynamic> productData,
  }) async {
    await db
        .collection("tbl_users")
        .doc(uid)
        .collection('cart')
        .doc("${productData['id']}")
        .set(productData);
  }

  Future<void> insertFavouriteData({
    required String uid,
    required Map<String, dynamic> productData,
  }) async {
    await db
        .collection("tbl_users")
        .doc(uid)
        .collection('favourite')
        .doc("${productData['id']}")
        .set(productData);
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getCartData(
      {required String uid}) async {
    QuerySnapshot<Map<String, dynamic>> userData;

    userData =
        await db.collection("tbl_users").doc(uid).collection('cart').get();
    return userData;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getFavouriteData(
      {required String uid}) async {
    QuerySnapshot<Map<String, dynamic>> userData;

    userData =
        await db.collection("tbl_users").doc(uid).collection('favourite').get();
    return userData;
  }

  Future<void> deleteParticularCartData(
      {required String uid, required String id}) async {
    await db
        .collection("tbl_users")
        .doc(uid)
        .collection('cart')
        .doc(id)
        .delete();
  }
  Future<void> deleteParticularFavouriteData(
      {required String uid, required String id}) async {
    await db
        .collection("tbl_users")
        .doc(uid)
        .collection('favourite')
        .doc(id)
        .delete();
  }

  Future<void> increseQuantity(
      {required String uid, required String id, required int quantity}) async {
    await db
        .collection("tbl_users")
        .doc(uid)
        .collection('cart')
        .doc(id)
        .update({'quantity': ++quantity});
  }

  Future<void> decreseQuantity(
      {required String uid, required String id, required int quantity}) async {
    await db
        .collection("tbl_users")
        .doc(uid)
        .collection('cart')
        .doc(id)
        .update({'quantity': --quantity});
  }

  // Future<void> updateCart(
  //     {required String uid, required List productData}) async {
  //   await db.collection("tbl_users").doc(uid).update({
  //     'cart': FieldValue.arrayUnion(productData),
  //   });
  // }

  // Future<void> increseQuantity({
  //   required String uid,
  //   required int index,
  //   required List<dynamic> productData,
  //   required int quantity,
  // }) async {
  //   // productData[index]['quantity'] = ++quantity;

  //   List totalProduct = productData;
  //   totalProduct[index]['quantity'] = ++quantity;
  //   print(totalProduct[index]);

  //   await db.collection('tbl_users').doc(uid).update({
  //     ['cart'][index]: {totalProduct[index]},
  //   });
  // }

  // Future<void> decreseQuantity({
  //   required String uid,
  //   required int index,
  //   required Map<String, dynamic> productData,
  //   required int quantity,
  // }) async {
  //   productData['quantity'] = --quantity;

  //   await db.collection('tbl_users').doc(uid).update({
  //     ['cart'][index]: {
  //       productData,
  //     }
  //   });
  // }

  Future<void> deleteCartData(
      {required String uid,
      required List productData,
      required int index}) async {
    await db.collection("tbl_users").doc(uid).update({
      'cart': FieldValue.arrayRemove([productData[index]]),
    });
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getParticularProductData(
      {required String type}) async {
    QuerySnapshot<Map<String, dynamic>> fruitData;

    fruitData = await db
        .collection("tbl_products")
        .where('type', isEqualTo: type)
        .get();

    return fruitData;
  }

  Future<void> updateAddress(
      {required String uid,
      required String location,
      required String city}) async {
    await db
        .collection("tbl_users")
        .doc(uid)
        .update({'location': location, 'city': city});
  }

  // Future<QuerySnapshot<Map<String, dynamic>>> fetchCartRecords(
  //     {required String uid}) async  {
  //   return await db.collection("tbl_users").where('uid', isEqualTo: uid).get();
  // }
}
