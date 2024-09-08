class DoctorModel {
  final String? doctorName;
  final String? doctorImage;
  final String? doctorSubject;
  final String? grade;

  DoctorModel(
      {required this.doctorName,
      required this.doctorImage,
      required this.doctorSubject,
      required this.grade});

  factory DoctorModel.jsonData(jsonData) {
    return DoctorModel(
        doctorName: jsonData['doctorName'],
        doctorImage: jsonData['doctorImage'],
        doctorSubject: jsonData['doctorSubject'],
        grade: jsonData['Grade']);
  }
}
