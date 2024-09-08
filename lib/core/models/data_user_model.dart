import 'dart:convert';

class DataUserModel {
  final String email;
  final String name;
  final String age;
  final String collage;
  final String grade;
  final String group;
  final String image;
  final int status;

  DataUserModel({
    required this.email,
    required this.name,
    required this.age,
    required this.collage,
    required this.grade,
    required this.group,
    required this.image,
    required this.status,
  });

  factory DataUserModel.jsonData(jsonData) {
    return DataUserModel(
      email: jsonData['email'],
      name: jsonData['name'],
      age: jsonData['age'],
      collage: jsonData['collage'],
      grade: jsonData['grade'],
      group: jsonData['group'],
      image: jsonData['image'],
      status: jsonData['status'],
    );
  }
}
