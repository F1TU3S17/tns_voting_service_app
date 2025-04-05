import 'package:flutter/material.dart';
import 'package:tns_voting_service_app/all_information_story/domain/model/info_question_screen_model.dart';

class InfoStoryScreenModelProvider extends InheritedNotifier {
  const InfoStoryScreenModelProvider(
      {super.key, required this.model, required this.child})
      : super(child: child, notifier: model);

  final InfoStoryScreenModel model;
  final Widget child;

  static InfoStoryScreenModelProvider? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<InfoStoryScreenModelProvider>();
  }
}
