import 'package:flutter/material.dart';
import 'package:tns_voting_service_app/theme/theme.dart';

ThemeData getCurrentTheme(bool isDarkTheme){
  if (isDarkTheme) {
    return AppTheme.darkTheme;
  } else {
    return AppTheme.ligthTheme;
  }
}
