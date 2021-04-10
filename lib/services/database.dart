import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:time_tracker/app/home/models/job.dart';
import 'package:time_tracker/services/api_path.dart';

abstract class Database {
  Future<void> createJob(Job job);
  Stream<List<Job>> jobsStream();
}

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;

  @override
  Future<void> createJob(Job job) => _setData(
        path: APIPath.job(uid, 'job_13'),
        data: job.toMap(),
      );

  Stream<List<Job>> jobsStream() {
    final path = APIPath.jobs(uid);
    final reference = FirebaseFirestore.instance.collection(path);
    final snapshots = reference.snapshots();

    return snapshots.map(
      (snapshot) => snapshot.docs.map(
        (snap) {
          final data = snap.data();
          return data ??
              Job(
                name: data['name'],
                ratePerHour: data['ratePerHour'],
              );
        },
      ),
    );
  }

  Future<void> _setData({String path, Map<String, dynamic> data}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    print('$path: $data');
    await reference.set(data);
  }
}
