import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  CustomListTile({super.key, required this.object, required this.IconO});

  final String object;
  final IconData IconO;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(IconO),
      title: Text(
        object,
        textAlign: TextAlign.start,
        style: TextStyle(
            color: Colors.black, fontFamily: 'Gilroy-Bold', fontSize: 16),
      ),
    );
  }
}
