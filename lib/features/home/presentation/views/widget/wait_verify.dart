import 'dart:ui';

import 'package:flutter/material.dart';

class WaitVerifyWidget extends StatelessWidget {
  const WaitVerifyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 290),
        Icon(
          Icons.verified,
          color: Colors.green,
          size: 64,
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          'Thank You For Your Submit ,',
          style: TextStyle(
              fontFamily: 'Gilroy-Bold', fontSize: 22, color: Colors.grey),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          textAlign: TextAlign.center,
          'Wait 24 Hours Untill Review Your Submition',
          style: TextStyle(fontFamily: 'Gilroy-Bold', fontSize: 32),
        ),
      ],
    );
  }
}
