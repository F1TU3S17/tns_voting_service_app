import 'package:tns_voting_service_app/core/models/department_model.dart';

import '../models/login_model.dart';
import '../models/question_model.dart';

abstract class VotingRepository {
  /// Авторизация пользователя
  Future<LoginResponse> login(String username, String password);

  /// Получение списка подразделений
  Future<List<Department>> getDepartments(); // Попросить список отделов

  /// Получение списка вопросов на голосование
  Future<List<QuestionShort>> getQuestions();

  /// Получение детальной информации о вопросе
  Future<QuestionDetail> getQuestionDetails(String questionId);

  /// Скачивание файла
  Future<String> downloadFile(String fileId, String fileName);

  /// Голосование
  Future<void> vote(String questionId, int answerId);

  /// Получение истории завершенных голосований
  Future<List<QuestionDetail>> getVotingHistory();

  /// Проверка авторизации
  bool get isAuthenticated;

  /// Выход из системы
  void logout();
}
