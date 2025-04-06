import 'package:flutter/material.dart';
import 'package:tns_voting_service_app/core/models/department_model.dart';
import 'package:tns_voting_service_app/core/repository/repository_provider.dart';
import 'package:tns_voting_service_app/core/repository/voting_repository.dart';

/// Модель данных для страницы выбора подразделения
///
/// Управляет состоянием и загрузкой данных для экрана со списком подрозделений.
/// Реализует паттерн Provider для обновления UI при изменении данных.
class DepartmentModel extends ChangeNotifier {
  /// Репозиторий для работы с данными подразделений.
  final VotingRepository repository = RepositoryProvider.getRepository();

  /// Список подразделений для отображения на домашней странице.
  List<Department> departments = [];

  /// Индикатор состояния загрузки данных.
  ///
  /// `true` - если данные загружаются, `false` - если загрузка завершена.
  bool isLoadind = true;

  /// Инициализирует список подразделений из репозитория.
  ///
  /// Устанавливает флаг загрузки в начале и конце операции.
  /// Уведомляет слушателей об обновлении данных.
  Future<void> initDepartments() async {
    isLoadind = true;
    departments = await repository.getDepartments();
    notifyListeners();
    isLoadind = false;
  }
}
