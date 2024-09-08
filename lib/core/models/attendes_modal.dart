class AttendesModal {
  final String? name;
  final String? image;
  final String? group;
  final String? attendUrl;

  AttendesModal(
      {required this.name,
      required this.image,
      required this.group,
      required this.attendUrl});
  factory AttendesModal.jsonData(jsonData) {
    return AttendesModal(
        name: jsonData['name'],
        image: jsonData['image'],
        group: jsonData['group'],
        attendUrl: jsonData['attendImage']);
  }
}
