import 'package:flutter/material.dart';
import 'package:tns_voting_service_app/core/models/question_model.dart';
import 'package:tns_voting_service_app/core/repository/repository_provider.dart';
import 'package:tns_voting_service_app/core/repository/voting_repository.dart';

class InfoScreenModel extends ChangeNotifier {
  /// Репозиторий для работы с данными голосования.
  final VotingRepository repository = RepositoryProvider.getRepository();

  /// Список вопросов для отображения на домашней странице.
  QuestionDetail? questionDetail;
  // ignore: prefer_typing_uninitialized_variables
  late final questionDate;

  InfoScreenModel(DateTime date) {
    questionDate = date;
  }

  /// Индикатор состояния загрузки данных.
  ///
  /// `true` - если данные загружаются, `false` - если загрузка завершена.
  bool isLoading = true;

  /// Инициализирует список вопросов из репозитория.
  /// Устанавливает флаг загрузки в начале и конце операции.
  /// Уведомляет слушателей об обновлении данных.
  Future<void> initQuestionDetail(String questionId) async {
    isLoading = true;
    questionDetail = (await repository.getQuestionDetails(questionId));
    notifyListeners();
    isLoading = false;
  }
}
