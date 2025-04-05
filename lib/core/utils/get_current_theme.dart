import 'package:flutter/material.dart';
import 'package:tns_voting_service_app/theme/theme.dart';

ThemeData getCurrentTheme(bool isDarkTheme){
  return isDarkTheme ? AppTheme.darkTheme : AppTheme.ligthTheme;
}
