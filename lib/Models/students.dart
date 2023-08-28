import 'dart:convert';

class Student {
  String? id;
  int rollno;
  String name;
  int marks;

  Student({
    this.id,
    required this.rollno,
    required this.name,
    required this.marks,
  });

  factory Student.fromRawJson(String str) => Student.fromJson(json.decode(str));
  String toRawJson() => json.encode(toJson());

  factory Student.fromJson(Map<String, dynamic> json) => Student(
        id: json["id"] ?? "",
        rollno: json['rollno'],
        name: json['name'],
        marks: json['marks'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'rollno': rollno,
        'name': name,
        'marks': marks,
      };
}
