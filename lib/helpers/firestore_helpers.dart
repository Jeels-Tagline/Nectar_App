import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreHelper {
  FirestoreHelper._();

  static final FirestoreHelper firestoreHelper = FirestoreHelper._();

  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> insertUsers({required Map<String, dynamic> data}) async {
    await db.collection("tbl_users").doc("${data['uid']}").set(data);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchUsers() {
    return db.collection("tbl_users").snapshots();
  }

  // Future<void> deleteRecords({required String id}) async {
  //   DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
  //       await db.collection("counter").doc("note_counter").get();

  //   Map<String, dynamic>? counterData = documentSnapshot.data();

  //   int length = counterData!['length'];

  //   await db.collection("tbl_").doc(id).delete();

  //   length--;

  //   await db
  //       .collection("counter")
  //       .doc("note_counter")
  //       .update({"length": length});
  // }

  Future<QuerySnapshot<Map<String, dynamic>>> getUserData(
      {required String uid}) async {
    QuerySnapshot<Map<String, dynamic>> userData;

    userData =
        await db.collection("tbl_users").where('uid', isEqualTo: uid).get();

    return userData;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getProductData({required String type}) async {
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
}
