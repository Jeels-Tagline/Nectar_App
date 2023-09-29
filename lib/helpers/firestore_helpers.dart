// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nectar_app/models/product_models.dart';

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

  Future<QuerySnapshot<Map<String, dynamic>>> getOrdersData(
      {required String uid}) async {
    QuerySnapshot<Map<String, dynamic>> userOrderData;

    userOrderData =
        await db.collection(userCollection).doc(uid).collection('orders').get();
    return userOrderData;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getProductOfOrderData({
    required String uid,
    required String orderId,
    required String date,
  }) async {
    QuerySnapshot<Map<String, dynamic>> userOrderData;

    userOrderData = await db
        .collection(userCollection)
        .doc(uid)
        .collection('orders')
        .doc(orderId)
        .collection(date)
        .get();
    return userOrderData;
  }

  Future<void> insertOrder({
    required String uid,
    required Map<String, dynamic> orders,
    required String time,
  }) async {
    await db
        .collection(userCollection)
        .doc(uid)
        .collection('orders')
        .doc(time)
        .set(orders);
  }

  Future<void> insertProductOfOrder({
    required String uid,
    required String productId,
    required String orderId,
    required String date,
    required String image,
    required String name,
    required String quantity,
    required String price,
  }) async {
    await db
        .collection(userCollection)
        .doc(uid)
        .collection('orders')
        .doc(orderId)
        .collection(date)
        .doc(productId)
        .set({
      'id': productId,
      'image': image,
      'name': name,
      'quantity': quantity,
      'price': price,
    });
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getOrdersId(
      {required String uid}) async {
    QuerySnapshot<Map<String, dynamic>> userData;

    userData =
        await db.collection(userCollection).doc(uid).collection('orders').get();

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

  Future<List<ProductModel>>? getSearchProductData({
    required String search,
    required List<String> filter,
  }) async {
    QuerySnapshot<Map<String, dynamic>> searchData;

    List<ProductModel> productList = [];
    List<ProductModel> list = [];
    List types = [
      'fruit',
      'vegetable',
      'bakery',
      'baverage',
      'pulses',
      'rice',
    ];

    // Secound way
    // searchData = await db
    //     .collection(productCollection)
    //     .where('name', isGreaterThanOrEqualTo: search)
    //     .where('name', isLessThan: search + 'z')
    //     .get();
    // productList = searchData.docs
    //     .map((e) => ProductModel.fromMap(data: e.data()))
    //     .toList();

    if (filter.isEmpty) {
      for (int i = 0; i < types.length; i++) {
        searchData = await db
            .collection(productCollection)
            .doc('BZI7tNyult29RjmDJ6Ls')
            .collection(types[i])
            .where('name', isGreaterThanOrEqualTo: search)
            .where('name', isLessThan: search + 'z')
            .get();

        list = searchData.docs
            .map((e) => ProductModel.fromMap(data: e.data()))
            .toList();

        for (int i = 0; i < list.length; i++) {
          productList.add(list[i]);
        }
      }
    } else {
      for (int i = 0; i < filter.length; i++) {
        search = filter[i];
        for (int i = 0; i < types.length; i++) {
          searchData = await db
              .collection(productCollection)
              .doc('BZI7tNyult29RjmDJ6Ls')
              .collection(types[i])
              .where('name', isGreaterThanOrEqualTo: search)
              .where('name', isLessThan: search + 'z')
              .get();

          list = searchData.docs
              .map((e) => ProductModel.fromMap(data: e.data()))
              .toList();

          for (int i = 0; i < list.length; i++) {
            productList.add(list[i]);
          }
        }
      }
    }

    return productList;
  }
}
