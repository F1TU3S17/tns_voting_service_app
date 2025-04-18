import 'package:flutter/material.dart';
import 'package:tns_voting_service_app/department_select/presentation/department_select_screen.dart';
import 'package:tns_voting_service_app/home/presentation/screens/home_screen.dart';
import 'package:tns_voting_service_app/my_profile/presentation/screens/my_profile_screen.dart';

class NavbarModel extends ChangeNotifier {
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  final List<Widget> _screens = [
    DepartmentSelectScreen(),
    MyProfileScreen(),
  ];

  void changeItem(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  Widget getCurrentPage() {
    return _screens[_currentIndex];
  }
}
