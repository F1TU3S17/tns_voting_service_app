import 'package:flutter/material.dart';
import 'package:tns_voting_service_app/home/domain/model/home_screen_model.dart';

class HomeScreenModelProvider extends InheritedNotifier {
  const HomeScreenModelProvider({super.key, required this.model, required this.child}) : super(child: child, notifier: model);

  final HomeScreenModel model;
  final Widget child;

  static HomeScreenModelProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<HomeScreenModelProvider>();
  }

}