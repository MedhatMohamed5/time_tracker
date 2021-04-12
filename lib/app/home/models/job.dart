import 'package:flutter/foundation.dart';

class Job {
  Job({@required this.id, @required this.name, @required this.ratePerHour});
  final String name;
  final int ratePerHour;
  final String id;

  factory Job.fromMap(Map<String, dynamic> data, String docId) {
    if (data == null) return null;
    return Job(
      id: docId,
      name: data['name'] ?? '',
      ratePerHour: data['ratePerHour'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'ratePerHour': ratePerHour,
    };
  }
}
