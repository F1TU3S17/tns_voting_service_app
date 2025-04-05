import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:path/path.dart' as path;
import 'package:tns_voting_service_app/core/database/app_database.dart';
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

  int? voteOptionId;

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
    voteOptionId = await getVote(questionId);
    notifyListeners();
    isLoading = false;
  }

  Future<String> downloadFile(String fileId, String fileName) async {
    return await repository.downloadFile(fileId, fileName);
  }

  Future<int?> getVote(String questionId) async {
    return await AppDatabase.getVote(questionId);
  }

  Future<void> saveVote(String questionId, int voteId) async {
    await AppDatabase.saveVote(questionId, voteId);
  }

  Future<void> saveVoteOption(int voteId) async {
    await saveVote(questionDetail!.id, voteId);
    voteOptionId = voteId;
    notifyListeners();
  }

  String? getVoteTextByVoteId() {
    return _voteOptions[voteOptionId];
  }

  Future<String?> getVoteText(String questionId) async {
    final voteId = await getVote(questionId);
    return _voteOptions[voteId!];
  }

  static const Map<int?, String?> _voteOptions = {
    0: 'Поддержать',
    1: 'Воздержаться',
    2: 'Против',
    null: null,
  };
}
