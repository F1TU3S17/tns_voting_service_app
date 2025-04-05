import 'package:flutter/material.dart';

Widget buildColoredPercentageText() {
  return RichText(
    text: TextSpan(
      children: [
        TextSpan(
          text: '51%',
          style: TextStyle(color: Colors.green),
        ),
        TextSpan(text: ' / '),
        TextSpan(
          text: '9%',
          style: TextStyle(color: Colors.orange),
        ),
        TextSpan(text: ' / '),
        TextSpan(
          text: '40%',
          style: TextStyle(color: Colors.red),
        ),
      ],
    ),
  );
}
