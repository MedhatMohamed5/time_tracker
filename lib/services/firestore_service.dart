import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirestoreService {
  FirestoreService._();
  static final instance = FirestoreService._();
  Future<void> setData({
    @required String path,
    @required Map<String, dynamic> data,
  }) async {
    final reference = FirebaseFirestore.instance.doc(path);
    print('$path: $data');
    await reference.set(data);
  }

  Stream<List<T>> collectionStream<T>({
    @required String path,
    @required T Function(Map<String, dynamic> data, String docId) builder,
    String orderBy,
  }) {
    final reference = orderBy != null
        ? FirebaseFirestore.instance.collection(path).orderBy(orderBy)
        : FirebaseFirestore.instance.collection(path);
    final snapshots = reference.snapshots();

    return snapshots.map(
      (snapshot) => snapshot.docs
          .map(
            (snap) => builder(snap.data(), snap.id),
          )
          .toList(),
    );
  }

  Future<void> deleteData({@required String path}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    print('delete: $path');
    await reference.delete();
  }
}
