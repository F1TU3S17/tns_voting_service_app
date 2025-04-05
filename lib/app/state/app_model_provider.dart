import 'package:flutter/material.dart';
import 'package:tns_voting_service_app/app/models/app_model.dart';

class AppModelProvider extends InheritedNotifier {
  const AppModelProvider({super.key, required this.appModel, required this.child}) : super(child: child, notifier: appModel);

  final AppModel appModel;
  final Widget child;

  static AppModelProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppModelProvider>();
  }

  
}