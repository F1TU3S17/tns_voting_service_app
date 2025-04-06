import 'package:flutter/material.dart';
import 'package:tns_voting_service_app/theme/theme.dart';

Widget getFileIcon(String fileType, bool isDark) {
  switch (fileType) {
    case 'pdf':
      return Icon(
        Icons.picture_as_pdf,
        color: isDark ? AppTheme.darkAccentColor : Colors.red,
        size: 24,
      );
    case 'doc':
    case 'ocx':
      return Icon(
        Icons.description,
        color: isDark ? AppTheme.darkAccentColor : Colors.blue,
        size: 24,
      );
    case 'png':
    case 'jpg':
    case 'peg':
    case 'gif':
      return Icon(
        Icons.image,
        color: isDark ? AppTheme.darkAccentColor : Colors.green,
        size: 24,
      );
    case 'xls':
    case 'lsx':
      return Icon(
        Icons.table_chart,
        color: isDark ? AppTheme.darkAccentColor : Colors.green[700],
        size: 24,
      );
    case 'zip':
    case 'rar':
      return Icon(
        Icons.archive,
        color: isDark ? AppTheme.darkAccentColor : Colors.orange,
        size: 24,
      );
    default:
      return Icon(
        Icons.insert_drive_file,
        color: isDark ? AppTheme.darkAccentColor : Colors.grey,
        size: 24,
      );
  }
}
