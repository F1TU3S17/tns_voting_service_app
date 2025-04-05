import 'dart:ui';
import 'package:flutter/material.dart';

Widget buildTableHeader(String title, Color color) {
  return Builder(builder: (context) {
    final theme = Theme.of(context);
    theme.colorScheme.secondary;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(
              color: Colors.transparent,
              width: 1,
            ),
          ),
        ),
        child: Text(
          title,
          textAlign: TextAlign.left,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  });
}
