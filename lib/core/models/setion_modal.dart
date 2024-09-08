class SetionModel {
  final String? docName;
  final String? date;
  final int? status;
  final String? group;

  SetionModel(
      {required this.docName,
      required this.date,
      required this.status,
      required this.group});

  factory SetionModel.jsonData(jsonData) {
    return SetionModel(
        docName: jsonData['name'],
        date: jsonData['data'],
        status: jsonData['status'],
        group: jsonData['Group']);
  }
}
