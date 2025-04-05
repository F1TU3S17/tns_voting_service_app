import 'package:flutter/material.dart';
import 'package:tns_voting_service_app/auth/domain/model/auth_screen_model.dart';

class AuthScreenModelProvider extends InheritedNotifier<AuthScreenModel> {
  const AuthScreenModelProvider({
    super.key,
    required super.child,
    required AuthScreenModel model,
  }) : super(notifier: model);

  static AuthScreenModel? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<AuthScreenModelProvider>()
        ?.notifier;
  }
}
