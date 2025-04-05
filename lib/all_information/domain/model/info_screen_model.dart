import 'package:flutter/material.dart';
import 'package:tns_voting_service_app/core/models/question_model.dart';
import 'package:tns_voting_service_app/core/repository/repository_provider.dart';
import 'package:tns_voting_service_app/core/repository/voting_repository.dart';

class InfoScreenModel extends ChangeNotifier {
  /// Репозиторий для работы с данными голосования.
  final VotingRepository repository = RepositoryProvider.getRepository();

  /// Список вопросов для отображения на домашней странице.
  List<QuestionShort> questions = [];

  /// Индикатор состояния загрузки данных.
  ///
  /// `true` - если данные загружаются, `false` - если загрузка завершена.
  bool isLoadind = true;

  /// Инициализирует список вопросов из репозитория.
  /// Устанавливает флаг загрузки в начале и конце операции.
  /// Уведомляет слушателей об обновлении данных.
  Future<void> initQuestions() async {
    isLoadind = true;
    questions = await repository.getQuestions();
    notifyListeners();
    isLoadind = false;
  }
}
