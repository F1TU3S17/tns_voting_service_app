import 'package:flutter/material.dart';
import 'package:tns_voting_service_app/nav_bar/domain/state/navbar_model.dart';

class NavbarModelProvider extends InheritedNotifier {
  const NavbarModelProvider(
      {super.key, required this.model, required this.child})
      : super(child: child, notifier: model);

  final NavbarModel model;
  final Widget child;

  static NavbarModelProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<NavbarModelProvider>();
  }
}
