import 'package:flutter/material.dart';
import '../job_entries/format.dart';
import 'entry.dart';
import 'job.dart';

class EntryListItemModel {
  final Entry entry;
  final Job job;

  EntryListItemModel({@required this.entry, @required this.job});

  String get dayOfWeek => Format.dayOfWeek(entry.start);
  String get startDate => Format.date(entry.start);
  TimeOfDay get startTime => TimeOfDay.fromDateTime(entry.start);
  TimeOfDay get endTime => TimeOfDay.fromDateTime(entry.end);
  String get durationFormatted => Format.hours(entry.durationInHours);

  double get pay => job.ratePerHour * entry.durationInHours;
  String get payFormatted => Format.currency(pay);
}
