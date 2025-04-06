import 'package:flutter/material.dart';
import 'package:tns_voting_service_app/department_select/domain/state/department_model.dart';

class DepartmentModelProvider extends InheritedNotifier<DepartmentModel> {
  const DepartmentModelProvider({
    super.key,
    required super.child,
    required DepartmentModel model,
  }) : super(notifier: model);

  static DepartmentModel? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<DepartmentModelProvider>()
        ?.notifier;
  }
}
