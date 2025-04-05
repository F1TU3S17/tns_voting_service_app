import 'package:flutter/material.dart';
import 'package:tns_voting_service_app/all_information/domain/model/info_screen_model.dart';

class InfoScreenModelProvider extends InheritedNotifier {
  const InfoScreenModelProvider(
      {super.key, required this.model, required this.child})
      : super(child: child, notifier: model);

  final InfoScreenModel model;
  final Widget child;

  static InfoScreenModelProvider? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<InfoScreenModelProvider>();
  }
}
