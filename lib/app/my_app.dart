import 'package:flutter/material.dart';
import 'package:tns_voting_service_app/nav_bar/presentation/widgets/main_navigation.dart';
import 'package:tns_voting_service_app/theme/theme.dart';

class TnsApp extends StatelessWidget {
  const TnsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.ligthTheme,
      home: const MainNavigation(),
    );
  }
}
