import 'dart:io';
import 'dart:math';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:tns_voting_service_app/core/entity/user.dart';
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
    final List<String> realTitles = [
      'Утверждение годового отчета за 2023 г.',
      'Распределение прибыли за 2023 г.',
      'Выплата дивидендов за 2023 г.',
      'Избрание Совета директоров',
      'Утверждение аудитора на 2024 г.',
      'Одобрение сделки с ПАО Сбербанк',
      'Изменения в Устав Общества',
      'Положение о выплатах Совету директоров',
    ];
    
    final List<String> realDescriptions = [
      'Согласно п. 11 ст. 65 ФЗ "Об акционерных обществах" вопросы годового отчета должны быть предварительно утверждены Советом директоров Общества',
      'В соответствии с данными бухгалтерской отчетности Общества за 2023 год, чистая прибыль составила 284,7 млн. руб. Совет директоров рекомендует направить 50% чистой прибыли на выплату дивидендов, оставшуюся часть - на инвестиционные проекты и погашение кредитов.',
      'Совет директоров рекомендует выплатить дивиденды по обыкновенным акциям Общества по итогам 2023 года в размере 0,132548 руб. на одну акцию в денежной форме в срок до 31 декабря 2024 года.',
      'В соответствии с Уставом Общества, количественный состав Совета директоров составляет 7 человек. Акционерам предлагается избрать Совет директоров из кандидатов, выдвинутых акционерами Общества.',
      'Предлагается утвердить ООО "Эрнст энд Янг" в качестве аудитора бухгалтерской отчетности Общества по РСБУ и МСФО на 2024 год.',
      'Рассмотрение вопроса о предоставлении согласия на заключение кредитного договора с ПАО Сбербанк на сумму 1,7 млрд рублей для рефинансирования текущей задолженности.',
      'Предлагается внести изменения в Устав Общества в связи с изменениями требований действующего законодательства.',
      'Предлагается утвердить новую редакцию Положения о выплате членам Совета директоров Общества вознаграждений и компенсаций.',
    ];

    final List<String> fileNames = [
      'Годовой отчет ПАО ТНС энерго за 2023 год.pdf',
      'Бухгалтерская отчетность за 2023 год.pdf',
      'Заключение Ревизионной комиссии.pdf',
      'Проект решения Совета директоров.pdf',
      'Заключение аудитора.pdf',
      'Проект изменений в Устав.pdf',
      'Пояснительная записка.pdf',
      'Расчет стоимости чистых активов.pdf',
      'Список кандидатов в Совет директоров.pdf',
      'Проект Положения о выплате вознаграждений.pdf',
    ];
    
    final List<String> departmentIds = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10'];

    for (int i = 1; i <= 8; i++) {
      final String id = 'q$i';
      final int votersTotal = 10 + _random.nextInt(16); // От 10 до 25
      final int votersCount = _random.nextInt(votersTotal);
      final questionShort = QuestionShort(
        id: id,
        title: realTitles[i - 1],
        description: realDescriptions[i - 1].substring(0, min(100, realDescriptions[i - 1].length)) + '...',
        departmentId: departmentIds[_random.nextInt(departmentIds.length)],
        votersCount: votersCount,
        votersTotal: votersTotal,
        endDate: DateTime.now().add(Duration(days: _random.nextInt(14) + 1)),
      );
      _questions.add(questionShort);

      // Создаем детальную информацию для каждого вопроса
      final List<FileInfo> files = [];
      final int filesCount = _random.nextInt(3) + 1;
      final List<int> selectedFileIndices = [];
      
      for (int j = 0; j < filesCount; j++) {
        int fileIndex;
        do {
          fileIndex = _random.nextInt(fileNames.length);
        } while (selectedFileIndices.contains(fileIndex));
        
        selectedFileIndices.add(fileIndex);
        final String fileId = '${id}_file$fileIndex';
        final String fileName = fileNames[fileIndex];
        files.add(FileInfo(id: fileId, name: fileName));
        _files[fileId] = 'Содержимое файла ${fileName}';
      }

      _questionDetails[id] = QuestionDetail(
        id: id,
        title: realTitles[i - 1],
        description: realDescriptions[i - 1],
        files: files,
        votersCount: votersCount,
        votersTotal: votersTotal,
        votingType: i % 3 == 0 ? VotingType.com : VotingType.bod,
        votingWay: i % 4 == 0 ? VotingWay.unanimous : VotingWay.majority,
        conferenceLink: 'https://zoom.us/j/${900000000 + _random.nextInt(99999999)}',
        departmentId: departmentIds[_random.nextInt(departmentIds.length)],
      );
    }

    // Создаем историю завершенных голосований
    final List<String> completedTitles = [
      'Промежуточные дивиденды за 9 мес. 2023 г.',
      'Бизнес-план на 2024 г.',
      'Договор с ООО "Энергосбыт"',
      'Выбор страховой компании на 2024 г.',
      'Одобрение сделки с заинтересованностью',
    ];
    
    final List<String> completedDescriptions = [
      'На основании данных промежуточной бухгалтерской отчетности за 9 месяцев 2023 года принято решение о выплате дивидендов в размере 0,08 руб. на одну обыкновенную акцию.',
      'Бизнес-план на 2024 год утвержден с плановыми показателями: выручка - 24,7 млрд руб., EBITDA - 1,2 млрд руб., чистая прибыль - 350 млн руб.',
      'Одобрено заключение договора поставки электроэнергии с ООО "Энергосбыт" на период с 01.01.2024 по 31.12.2024 на сумму 1,8 млрд руб.',
      'По результатам тендера выбрана АО "Согласие" в качестве страховой компании для страхования имущества и ответственности на 2024 год.',
      'Одобрена сделка по предоставлению поручительства ПАО "ТНС энерго Ростов-на-Дону" перед ВТБ (ПАО) по кредитному договору на сумму 800 млн руб.',
    ];

    for (int i = 0; i < 5; i++) {
      final String id = 'hist${i + 1}';
      final List<FileInfo> files = [];
      final String fileId = '${id}_protocol';
      final String fileName = 'Протокол голосования №${1000 + i} от ${_formatDate(DateTime.now().subtract(Duration(days: 30 + i * 15)))}.pdf';
      files.add(FileInfo(id: fileId, name: fileName));
      _files[fileId] = 'Содержимое протокола голосования #$i';
      final int votersTotal = 10 + _random.nextInt(16); // От 10 до 25

      _votingHistory.add(QuestionDetail(
        id: id,
        title: completedTitles[i],
        description: completedDescriptions[i],
        files: files,
        votersCount: votersTotal, // Для завершенных - все проголосовали
        votersTotal: votersTotal,
        votingType: i % 2 == 0 ? VotingType.com : VotingType.bod,
        votingWay: i % 3 == 0 ? VotingWay.unanimous : VotingWay.majority,
        conferenceLink: '',
        departmentId: departmentIds[_random.nextInt(departmentIds.length)],
      ));
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
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
      Department(id: 8, name: 'АО «ТНС энерго Карелия»', voteCount: 7),
      Department(id: 9, name: 'ООО «ТНС энерго Пенза»', voteCount: 7),
      Department(id: 10, name: 'ООО «ТНС энерго Великий Новгород»', voteCount: 5),
    ];
    await Future.delayed(Duration(milliseconds: 800));
    if (_token == null) {
      throw Exception('Токен недействителен');
    }
    return _mockData.map((d) => d.copyWith()).toList(); // Отправляем копии
  }

  @override
  Future<User> getUserInfo() async {
    await Future.delayed(Duration(milliseconds: 800));
    if (_token == null) {
      throw Exception('Токен недействителен');
    }
    return User(
      id: 1,
      email: "petrov.a@tns-e.ru",
      emailVerifiedAt: DateTime.now().subtract(Duration(days: 120)),
      createdAt: DateTime.now().subtract(Duration(days: 365)),
      updatedAt: DateTime.now().subtract(Duration(days: 30)),
      ethAccount: "0x7FdC932Ab727A944C4458640da92124e8064D70B",
      name: "Петров Александр Михайлович",
    );
  }
}
