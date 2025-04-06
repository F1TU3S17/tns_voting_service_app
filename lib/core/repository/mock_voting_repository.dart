import 'dart:io';
import 'dart:math';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:tns_voting_service_app/core/models/department_model.dart';
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
        departmentId: '0',
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
        votingType: _random.nextBool() ? VotingType.com : VotingType.bod,
        votingWay:
            _random.nextBool() ? VotingWay.majority : VotingWay.unanimous,
        conferenceLink: 'https://zoom.us/j/123456789', departmentId: '1',
      );
    }

    // Создаем историю завершенных голосований
    for (int i = 1; i <= 3; i++) {
      final String id = 'hist${i + 3}';
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
        votingType: _random.nextBool() ? VotingType.com : VotingType.bod,
        votingWay:
            _random.nextBool() ? VotingWay.majority : VotingWay.unanimous,
        conferenceLink: 'https://zoom.us/j/123456789', departmentId: '1',
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
  Future<String> downloadFile(String fileId, String fileName) async {
    try {
      // Получаем безопасное имя файла
      var safeName = fileName.replaceAll(RegExp(r'[^\w\s\.\-]'), '_');

      // Проверяем расширение файла и добавляем .pdf если нет
      if (!safeName.toLowerCase().endsWith('.pdf')) {
        safeName = '$safeName.pdf';
      }

      Directory directory;

      if (Platform.isAndroid) {
        // Android-специфичный код
        // Получаем информацию о версии Android
        final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
        final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        final int sdkInt = androidInfo.version.sdkInt;

        if (sdkInt >= 30) {
          // Android 11+
          // Для Android 11+ используем директорию приложения
          directory = await getApplicationDocumentsDirectory();
        } else if (sdkInt >= 29) {
          // Android 10
          directory = await getApplicationDocumentsDirectory();
        } else {
          // Android 9 и ниже
          var status = await Permission.storage.status;
          if (!status.isGranted) {
            status = await Permission.storage.request();
            if (!status.isGranted) {
              throw Exception('Нет разрешения на запись в хранилище');
            }
          }
          directory = await getApplicationDocumentsDirectory();
        }
      } else if (Platform.isIOS) {
        // iOS-специфичный код
        // Для iOS лучше использовать временную директорию для файлов,
        // которые будут открываться другими приложениями
        directory = await getTemporaryDirectory();
      } else {
        // Для других платформ
        directory = await getApplicationDocumentsDirectory();
      }

      // Создаем директорию "Files"
      final filesDir = Directory('${directory.path}/Files');
      if (!await filesDir.exists()) {
        await filesDir.create(recursive: true);
      }

      // Формируем полный путь к файлу
      final filePath = path.join(filesDir.path, safeName);
      final file = File(filePath);

      // Проверяем, существует ли файл уже
      if (await file.exists()) {
        debugPrint('Файл уже существует: $filePath');

        // Для iOS проверяем размер файла, чтобы убедиться, что он не поврежден
        if (Platform.isIOS) {
          final fileSize = await file.length();
          if (fileSize <= 0) {
            debugPrint(
                'Существующий файл имеет нулевой размер, загрузим заново');
          } else {
            return filePath;
          }
        } else {
          return filePath;
        }
      }

      final url =
          "https://raa.ru/wp-content/uploads/2018/08/%D0%97%D0%B0%D0%BA%D0%BE%D0%BD-%D0%BA%D0%B0%D0%BA-%D0%BE%D1%81%D0%BD%D0%BE%D0%B2%D0%BD%D0%BE%D0%B9-%D0%B8%D1%81%D1%82%D0%BE%D1%87%D0%BD%D0%B8%D0%BA-%D1%80%D0%BE%D1%81%D1%81%D0%B8%D0%B9%D1%81%D0%BA%D0%BE%D0%B3%D0%BE-%D0%BF%D1%80%D0%B0%D0%B2%D0%B0.pdf";

      // Скачиваем файл
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Проверяем наличие контента
        if (response.bodyBytes.isEmpty) {
          throw Exception('Получен пустой файл');
        }

        // Сохраняем файл
        await file.writeAsBytes(response.bodyBytes);

        // Проверяем, что файл действительно сохранен
        if (!await file.exists() || await file.length() <= 0) {
          throw Exception('Файл не сохранен или имеет нулевой размер');
        }

        debugPrint('Файл успешно сохранен: $filePath');
        return filePath;
      } else {
        throw Exception('Ошибка HTTP: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Ошибка при скачивании файла: $e');
      throw Exception('Ошибка загрузки: $e');
    }
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

  @override
  Future<List<Department>> getDepartments() async {
    final List<Department> _mockData = [
      Department(id: 0, name: 'ПАО ГК «ТНС энерго»', voteCount: 9),
      Department(id: 1, name: 'ПАО «ТНС энерго Ростов-на-Дону»', voteCount: 7),
      Department(id: 2, name: 'ПАО «ТНС энерго Воронеж»', voteCount: 7),
      Department(id: 3, name: 'ПАО «ТНС энерго НН»', voteCount: 7),
      Department(id: 4, name: 'ПАО «ТНС энерго Ярославль»', voteCount: 7),
      Department(id: 5, name: 'ПАО «ТНС энерго Марий Эл»', voteCount: 7),
      Department(id: 6, name: 'ПАО «ТНС энерго Кубань»', voteCount: 7),
      Department(id: 7, name: 'АО «ТНС энерго Тула»', voteCount: 6),
      Department(id: 8, name: 'АО «ТНС энерго Карелия', voteCount: 7),
      Department(id: 9, name: 'ООО «ТНС энерго Пенза»', voteCount: 7),
      Department(
          id: 10, name: 'ООО «ТНС энерго Великий Новгород»', voteCount: 5),
    ];
    await Future.delayed(Duration(milliseconds: 800));
    if (_token == null) {
      throw Exception('Токен недействителен');
    }
    return _mockData.map((d) => d.copyWith()).toList(); // Отправляем копии
  }

}
