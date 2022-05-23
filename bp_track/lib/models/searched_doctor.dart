import 'package:bp_track/models/specialitati.dart';

class SearchedDoctor {
  String? nume;
  String? prenume;
  String? county;
  List<Specialitati?>? specializare;
  String? status;

  SearchedDoctor(
      {required this.nume,
      required this.prenume,
      required this.specializare,
      required this.county,
      required this.status});

  factory SearchedDoctor.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['specialitati'] as List;
    print(list);
    List<Specialitati> spec = list.map(((e) => Specialitati.fromJson(e))).toList();
    return SearchedDoctor(
        nume: parsedJson['nume'],
        prenume: parsedJson['prenume'],
        specializare: spec,
        county: parsedJson['judet'],
        status: parsedJson['status']);
  }
}
