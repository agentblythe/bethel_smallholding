import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreService {
  FireStoreService._();
  static final instance = FireStoreService._();

  Stream<List<T>> collectionStream<T>({
    required String path,
    required T Function(Map<String, dynamic> data, String documentID) builder,
  }) {
    final reference = FirebaseFirestore.instance.collection(path);
    final snapshots = reference.snapshots();

    return snapshots.map((querySnapshot) => querySnapshot.docs).map(
          (listOfDocSnap) => listOfDocSnap
              .map(
                (docSnap) => builder(
                  docSnap.data(),
                  docSnap.id,
                ),
              )
              .toList(),
        );
  }

  Future<void> setData(
      {required String path, required Map<String, dynamic> data}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    //print("$path: $data");
    await reference.set(data);
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getCollection(
      {required String path}) async {
    return await FirebaseFirestore.instance.collection(path).get();
  }
}
