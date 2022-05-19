import 'package:cloud_firestore/cloud_firestore.dart';

class LoggedEntry {
  int? systolic;
  int? diastolic;
  int? pulse;
  String? category;
  DateTime? time;

  LoggedEntry(
      {required this.systolic,
      required this.diastolic,
      required this.category,
      required this.pulse,
      required this.time});

  LoggedEntry.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : systolic = doc.data()?["systolic"],
        diastolic = doc.data()?["diastolic"],
        category = doc.data()?["category"],
        pulse = doc.data()?["pulse"],
        time = doc.data()?["time"].toDate();

  factory LoggedEntry.fromJson(Map<String, dynamic> parsedJson) {
    return LoggedEntry(
        systolic: parsedJson["systolic"],
        diastolic: parsedJson["diastolic"],
        category: parsedJson["category"],
        pulse: parsedJson["pulse"],
        time: parsedJson["time"].toDate());
  }
}
