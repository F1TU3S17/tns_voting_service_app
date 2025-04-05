import 'package:flutter/material.dart';

class AuthScreenModelProvider extends InheritedNotifier {
  const AuthScreenModelProvider(
      {super.key, required this.model, required this.child})
      : super(child: child, notifier: model);

  final AuthScreenModel model;
  final Widget child;

  static AuthScreenModelProvider? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<AuthScreenModelProvider>();
  }
}
