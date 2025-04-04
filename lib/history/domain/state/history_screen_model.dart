import 'package:flutter/material.dart';
import 'package:tns_voting_service_app/history/domain/model/history_screen_state.dart';

class HistoryScreenModelProvider extends InheritedNotifier {
  const HistoryScreenModelProvider(
      {super.key, required this.model, required this.child})
      : super(child: child, notifier: model);

  final HistoryScreenModel model;
  final Widget child;

  static HistoryScreenModelProvider? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<HistoryScreenModelProvider>();
  }
}
