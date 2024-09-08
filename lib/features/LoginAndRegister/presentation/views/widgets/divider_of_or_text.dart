import 'package:flutter/material.dart';

class DividerOfOrText extends StatelessWidget {
  const DividerOfOrText({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            thickness: 1,
            height: 1.5,
            color: Colors.grey,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text("OR"),
        ),
        Expanded(
          child: Divider(
            thickness: 1,
            height: 1.5,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
