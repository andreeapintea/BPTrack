class Specialitati {
  String? grade;
  String? name;
  String? practice;

  Specialitati(
      {required this.grade, required this.name, required this.practice});

  factory Specialitati.fromJson(Map<String, dynamic> parsedJson) {
    return Specialitati(
        grade: parsedJson['grad'],
        name: parsedJson['nume'],
        practice: parsedJson['drept_de_practica']);
  }
}
