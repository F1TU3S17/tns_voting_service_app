import 'package:flutter/material.dart';
import 'package:tns_voting_service_app/nav_bar/domain/state/navbar_model.dart';
import 'package:tns_voting_service_app/nav_bar/domain/state/navbar_model_provider.dart';
import 'package:tns_voting_service_app/nav_bar/presentation/widgets/current_screen_widget.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  final NavbarModel model = NavbarModel();

  @override
  Widget build(BuildContext context) {
    return NavbarModelProvider(
      model: model, 
      child: CurrentAppScreenWidget()
    );
  }
}