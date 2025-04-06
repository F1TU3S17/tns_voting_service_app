import 'package:flutter/material.dart';
import 'package:tns_voting_service_app/core/models/question_model.dart';
import 'package:tns_voting_service_app/core/repository/repository_provider.dart';
import 'package:tns_voting_service_app/core/repository/voting_repository.dart';

/// Модель данных для домашней страницы.
///
/// Управляет состоянием и загрузкой данных для экрана со списком вопросов.
/// Реализует паттерн Provider для обновления UI при изменении данных.
class HomeScreenModel extends ChangeNotifier{
  /// Репозиторий для работы с данными голосования.
  final VotingRepository repository = RepositoryProvider.getRepository(); 

  /// Список вопросов для отображения на домашней странице.
  List<QuestionShort> questions = [];
  
  /// Индикатор состояния загрузки данных.
  /// 
  /// `true` - если данные загружаются, `false` - если загрузка завершена.
  bool isLoadind = true;

  /// Инициализирует список вопросов из репозитория.
  ///
  /// Устанавливает флаг загрузки в начале и конце операции.
  /// Уведомляет слушателей об обновлении данных.
  Future<void> initQuestions(String departmentId) async{
    isLoadind = true;
    final allQuestions = await repository.getQuestions();
    final List<QuestionShort> _questions =[];
    for (var question in allQuestions) {
      if (question.departmentId == departmentId) {
        _questions.add(question);
      }
    }
    questions = _questions;
    notifyListeners();
    isLoadind = false;
  }
}