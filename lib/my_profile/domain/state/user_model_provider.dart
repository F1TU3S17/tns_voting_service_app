import 'package:flutter/material.dart';
import 'package:tns_voting_service_app/my_profile/domain/model/user_model.dart';

class UserModelProvider extends InheritedNotifier {
  const UserModelProvider({super.key, required this.child, required this.userModel}) : super(child: child, notifier: userModel );

  final Widget child;
  final UserModel userModel;

  static UserModelProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<UserModelProvider>();
  }

}