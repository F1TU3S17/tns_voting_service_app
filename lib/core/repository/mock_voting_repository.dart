import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';

import '../models/login_model.dart';
import '../models/question_model.dart';
import 'voting_repository.dart';

class MockVotingRepository implements VotingRepository {
  String? _token = 'dsadasjldsadjasldasj;da';
  final List<QuestionShort> _questions = [];
  final Map<String, QuestionDetail> _questionDetails = {};
  final List<QuestionDetail> _votingHistory = [];
  final Map<String, String> _files = {};
  final Random _random = Random();

  MockVotingRepository() {
    _initMockData();
  }

  void _initMockData() {
    // Создаем мок-данные для вопросов
    for (int i = 1; i <= 5; i++) {
      final String id = 'q$i';
      final int votersTotal = _random.nextInt(10) + 10;
      final questionShort = QuestionShort(
        id: id,
        title: 'Вопрос #$i',
        description: 'Описание вопроса #$i для голосования директоров',
        votersCount: _random.nextInt(votersTotal),
        votersTotal: votersTotal,
        endDate: DateTime.now().add(Duration(days: _random.nextInt(14) + 1)),
      );
      _questions.add(questionShort);

      // Создаем детальную информацию для каждого вопроса
      final List<FileInfo> files = [];
      for (int j = 1; j <= _random.nextInt(3) + 1; j++) {
        final String fileId = '${id}_file$j';
        final String fileName = 'Файл $j для вопроса #$i.pdf';
        files.add(FileInfo(id: fileId, name: fileName));
        _files[fileId] = 'Содержимое файла $j для вопроса #$i';
      }

      _questionDetails[id] = QuestionDetail(
        id: id,
        title: questionShort.title,
        description: questionShort.description,
        files: files,
        votersCount: questionShort.votersCount,
        votersTotal: questionShort.votersTotal,
        options: ['За', 'Против', 'Воздержаться'],
        votingType: _random.nextBool() ? VotingType.com : VotingType.bod,
        votingWay:
            _random.nextBool() ? VotingWay.majority : VotingWay.unanimous,
        conferenceLink: 'https://zoom.us/j/123456789',
      );
    }

    // Создаем историю завершенных голосований
    for (int i = 1; i <= 3; i++) {
      final String id = 'hist$i';
      final List<FileInfo> files = [];
      final String fileId = '${id}_protocol';
      final String fileName = 'Протокол голосования #$i.pdf';
      files.add(FileInfo(id: fileId, name: fileName));
      _files[fileId] = 'Содержимое протокола голосования #$i';
      final int votersTotal = _random.nextInt(10) + 10;

      _votingHistory.add(QuestionDetail(
        id: id,
        title: 'Завершенное голосование #$i',
        description: 'Описание завершенного голосования #$i',
        files: files,
        votersCount: _random.nextInt(votersTotal),
        votersTotal: votersTotal,
        options: ['За', 'Против', 'Воздержаться'],
        votingType: _random.nextBool() ? VotingType.com : VotingType.bod,
        votingWay:
            _random.nextBool() ? VotingWay.majority : VotingWay.unanimous,
        conferenceLink: 'https://zoom.us/j/123456789',
      ));
    }
  }

  @override
  Future<LoginResponse> login(String username, String password) async {
    await Future.delayed(Duration(seconds: 1));
    if (username == 'admin' && password == 'password') {
      _token = 'mock_jwt_token_${DateTime.now().millisecondsSinceEpoch}';
      return LoginResponse(token: _token!);
    } else {
      throw Exception('Неверные учетные данные');
    }
  }

  @override
  Future<List<QuestionShort>> getQuestions() async {
    await Future.delayed(Duration(milliseconds: 800));
    if (_token == null) {
      throw Exception('Токен недействителен');
    }
    return _questions;
  }

  @override
  Future<QuestionDetail> getQuestionDetails(String questionId) async {
    await Future.delayed(Duration(milliseconds: 800));
    if (_token == null) {
      throw Exception('Токен недействителен');
    }
    final details = _questionDetails[questionId];
    if (details == null) {
      throw Exception('Вопрос не найден');
    }
    return details;
  }

  @override
  Future<File> downloadFile(String fileId, String savePath) async {
    await Future.delayed(Duration(seconds: 1));
    if (_token == null) {
      throw Exception('Токен недействителен');
    }

    final fileContent = _files[fileId];
    if (fileContent == null) {
      throw Exception('Файл не найден');
    }

    // Если savePath не задан явно, создаем временный файл
    if (savePath.isEmpty) {
      //final directory = await getTemporaryDirectory();
      //savePath = '${directory.path}/mock_file_$fileId.pdf';
    }

    final file = File(savePath);
    await file.writeAsString(fileContent);
    return file;
  }

  @override
  Future<void> vote(String questionId, int answerId) async {
    await Future.delayed(Duration(milliseconds: 500));
    if (_token == null) {
      throw Exception('Токен недействителен');
    }

    if (!_questionDetails.containsKey(questionId)) {
      throw Exception('Неверные данные запроса');
    }

    if (answerId < 0 || answerId > 2) {
      throw Exception('Неверные данные запроса: недопустимый answerId');
    }

    // Имитация успешного голосования
    debugPrint('Голос принят: вопрос $questionId, ответ $answerId');
  }

  @override
  Future<List<QuestionDetail>> getVotingHistory() async {
    await Future.delayed(Duration(milliseconds: 800));
    if (_token == null) {
      throw Exception('Токен недействителен');
    }
    return _votingHistory;
  }

  @override
  bool get isAuthenticated => _token != null;

  @override
  void logout() {
    _token = null;
  }
}
