import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreHelper {
  FirestoreHelper._();
  final String userCollection = 'tbl_users';
  final String productCollection = 'tbl_products';

  static final FirestoreHelper firestoreHelper = FirestoreHelper._();

  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> insertUsers({required Map<String, dynamic> data}) async {
    await db.collection(userCollection).doc("${data['uid']}").set(data);
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchUsers() async {
    return await db.collection(userCollection).get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getUserData(
      {required String uid}) async {
    QuerySnapshot<Map<String, dynamic>> userData;

    userData =
        await db.collection(userCollection).where('uid', isEqualTo: uid).get();

    return userData;
  }

  Future<void> insertCartData({
    required String uid,
    required Map<String, dynamic> productData,
  }) async {
    await db
        .collection(userCollection)
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
        .collection(userCollection)
        .doc(uid)
        .collection('favourite')
        .doc("${productData['id']}")
        .set(productData);
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getCartData(
      {required String uid}) async {
    QuerySnapshot<Map<String, dynamic>> userData;

    userData =
        await db.collection(userCollection).doc(uid).collection('cart').get();
    return userData;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getFavouriteData(
      {required String uid}) async {
    QuerySnapshot<Map<String, dynamic>> userData;

    userData = await db
        .collection(userCollection)
        .doc(uid)
        .collection('favourite')
        .get();
    return userData;
  }

  Future<void> deleteParticularCartData(
      {required String uid, required String id}) async {
    await db
        .collection(userCollection)
        .doc(uid)
        .collection('cart')
        .doc(id)
        .delete();
  }

  Future<void> deleteParticularFavouriteData(
      {required String uid, required String id}) async {
    await db
        .collection(userCollection)
        .doc(uid)
        .collection('favourite')
        .doc(id)
        .delete();
  }

  Future<void> increseQuantity(
      {required String uid, required String id, required int quantity}) async {
    await db
        .collection(userCollection)
        .doc(uid)
        .collection('cart')
        .doc(id)
        .update({'quantity': ++quantity});
  }

  Future<void> decreseQuantity(
      {required String uid, required String id, required int quantity}) async {
    await db
        .collection(userCollection)
        .doc(uid)
        .collection('cart')
        .doc(id)
        .update({'quantity': --quantity});
  }

  Future<void> updateAddress(
      {required String uid,
      required String location,
      required String city}) async {
    await db
        .collection(userCollection)
        .doc(uid)
        .update({'location': location, 'city': city});
  }

  Future<void> updateUsernameAnduserphoto(
      {required String uid,
      required String photo,
      required String username}) async {
    await db
        .collection(userCollection)
        .doc(uid)
        .update({'photo': photo, 'displayName': username});
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

  // Future<QuerySnapshot<Map<String, dynamic>>> getParticularProductData(
  //     {required String type}) async {
  //   QuerySnapshot<Map<String, dynamic>> fruitData;
  //   fruitData = await db
  //       .collection(productCollection)
  //       .where('type', isEqualTo: type)
  //       .get();
  //   return fruitData;
  // }

  Future<QuerySnapshot<Map<String, dynamic>>> getParticularProductData(
      {required String type}) async {
    QuerySnapshot<Map<String, dynamic>> fruitData;

    fruitData = await db
        .collection(productCollection)
        .doc('BZI7tNyult29RjmDJ6Ls')
        .collection(type)
        .get();

    return fruitData;
  }

  // TODO : Search functionality
  Future<QuerySnapshot<Map<String, dynamic>>> getSearchProductData(
      {required String search}) async {
    // List<QuerySnapshot<Map<String, dynamic>>>? allFruitData;
    QuerySnapshot<Map<String, dynamic>>? fruitData;

    List types = [
      'fruit',
      'vegetable',
      'bakery',
      'baverage',
      'pulses',
      'rice',
    ];

    for (int i = 0; i < types.length; i++) {
      fruitData = await db
          .collection(productCollection)
          .doc('BZI7tNyult29RjmDJ6Ls')
          .collection('fruit')
          .where('name', isEqualTo: search)
          .get();
    }

    return fruitData!;
  }

  Future<void> insertOrders({
    required String uid,
    required String productId,
  }) async {
    await db
        .collection(userCollection)
        .doc(uid)
        .collection('orders')
        .doc()
        .set({'id': productId});
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getOrdersId(
      {required String uid}) async {
    QuerySnapshot<Map<String, dynamic>> userData;

    userData =
        await db.collection(userCollection).doc(uid).collection('orders').get();

    return userData;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getOrdersData(
      {required String id,
      required Function(dynamic context, dynamic snapShot) builder}) async {
    // List<QuerySnapshot<Map<String, dynamic>>>? allFruitData;
    QuerySnapshot<Map<String, dynamic>>? fruitData;

    List types = [
      'fruit',
      'vegetable',
      'bakery',
      'baverage',
      'pulses',
      'rice',
    ];

    for (int i = 0; i < types.length; i++) {
      fruitData = await db
          .collection(productCollection)
          .doc('BZI7tNyult29RjmDJ6Ls')
          .collection(types[i])
          .where('id', isEqualTo: id)
          .get();
    }

    return fruitData!;
  }
}
