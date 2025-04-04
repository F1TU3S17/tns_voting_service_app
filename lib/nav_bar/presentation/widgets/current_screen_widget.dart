import 'package:flutter/material.dart';
import 'package:tns_voting_service_app/nav_bar/domain/state/navbar_model.dart';
import 'package:tns_voting_service_app/nav_bar/domain/state/navbar_model_provider.dart';

class CurrentAppScreenWidget extends StatelessWidget {
  const CurrentAppScreenWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final NavbarModel model = NavbarModelProvider.of(context)!.model;
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        height: 60,
        destinations: [
          NavigationDestination(icon: Icon(Icons.how_to_vote_outlined), label: 'Главная'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Профиль'),
        ],
        onDestinationSelected: (value) => model.changeItem(value),
        selectedIndex: model.currentIndex,
      ),
      body: model.getCurrentPage(),
    );
  }
}