import 'package:flutter/material.dart';

class VerifyDoneHeader extends StatelessWidget {
  VerifyDoneHeader({super.key, required this.globalKey});

  final GlobalKey<ScaffoldState> globalKey;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          IconButton(
              onPressed: () {
                globalKey.currentState!.openDrawer();
              },
              icon: Icon(Icons.menu)),
        ],
      ),
    );
  }
}
