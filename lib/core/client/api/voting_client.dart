import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../models/login_model.dart';
import '../../models/question_model.dart';
import '../../models/vote_model.dart';
import 'package:path/path.dart' as path;

class VotingClient {
  final http.Client _client;
  final String _baseUrl;
  String? _token;
  final Duration _timeout = Duration(seconds: 15);

  VotingClient({String baseUrl = 'https://api.example.com/v1'})
      : _client = http.Client(),
        _baseUrl = baseUrl;

  Map<String, String> _getHeaders() {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    if (_token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }
    
    return headers;
  }

  Future<T> _handleResponse<T>(http.Response response, T Function(dynamic data) parser) {
    debugPrint('Статус ответа: ${response.statusCode}');
    
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = jsonDecode(response.body);
      return Future.value(parser(data));
    } else {
      switch (response.statusCode) {
        case 400:
          throw Exception('Неверные данные запроса');
        case 401:
          throw Exception('Неверные учетные данные или токен недействителен');
        case 403:
          throw Exception('Нет прав для выполнения операции');
        case 404:
          throw Exception('Ресурс не найден');
        default:
          throw Exception('Ошибка сервера: ${response.statusCode}');
      }
    }
  }

  /// Авторизация пользователя
  Future<LoginResponse> login(String username, String password) async {
    try {
      final response = await _client
          .post(
            Uri.parse('$_baseUrl/api/auth/login'),
            headers: _getHeaders(),
            body: jsonEncode(LoginRequest(username: username, password: password).toJson()),
          )
          .timeout(_timeout);

      return _handleResponse(
          response, (data) {
            final loginResponse = LoginResponse.fromJson(data);
            _token = loginResponse.token;
            return loginResponse;
          });
    } on http.ClientException catch (e) {
      throw Exception('Ошибка сети: ${e.message}');
    } on TimeoutException catch (_) {
      throw Exception('Превышено время ожидания ответа от сервера');
    } catch (e) {
      throw Exception('Ошибка авторизации: $e');
    }
  }

  /// Получение списка вопросов на голосование
  Future<List<QuestionShort>> getQuestions() async {
    try {
      final response = await _client
          .get(
            Uri.parse('$_baseUrl/api/voting/questions'),
            headers: _getHeaders(),
          )
          .timeout(_timeout);

      return _handleResponse(
          response,
          (data) => (data as List)
              .map((json) => QuestionShort.fromJson(json))
              .toList());
    } on http.ClientException catch (e) {
      throw Exception('Ошибка сети: ${e.message}');
    } on TimeoutException catch (_) {
      throw Exception('Превышено время ожидания ответа от сервера');
    } catch (e) {
      throw Exception('Ошибка получения вопросов: $e');
    }
  }

  /// Получение детальной информации о вопросе
  Future<QuestionDetail> getQuestionDetails(String questionId) async {
    try {
      final response = await _client
          .get(
            Uri.parse('$_baseUrl/api/voting/questions/$questionId'),
            headers: _getHeaders(),
          )
          .timeout(_timeout);

      return _handleResponse(
          response, (data) => QuestionDetail.fromJson(data));
    } on http.ClientException catch (e) {
      throw Exception('Ошибка сети: ${e.message}');
    } on TimeoutException catch (_) {
      throw Exception('Превышено время ожидания ответа от сервера');
    } catch (e) {
      throw Exception('Ошибка получения деталей вопроса: $e');
    }
  }

  /// Скачивание файла
  Future<String> downloadFile(String fileId, String fileName) async {
     try {
      // Получаем безопасное имя файла
      final safeName = fileName.replaceAll(RegExp(r'[^\w\s\.\-]'), '_');

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
        // На iOS используем стандартную директорию документов приложения
        directory = await getApplicationDocumentsDirectory();
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
        return filePath;
      }

      final url ="$_baseUrl/api/voting/files/$fileId"; // URL для скачивания файла
      // Скачиваем файл
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Сохраняем файл
        await file.writeAsBytes(response.bodyBytes);
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

  /// Голосование
  Future<void> vote(String questionId, int answerId) async {
    try {
      final response = await _client
          .post(
            Uri.parse('$_baseUrl/api/voting/vote'),
            headers: _getHeaders(),
            body: jsonEncode(VoteRequest(questionId: questionId, answerId: answerId).toJson()),
          )
          .timeout(_timeout);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        if (response.statusCode == 400) {
          throw Exception('Неверные данные запроса');
        } else if (response.statusCode == 401) {
          throw Exception('Токен недействителен');
        } else if (response.statusCode == 403) {
          throw Exception('Нет права голосовать по этому вопросу');
        }
        throw Exception('Ошибка голосования: ${response.statusCode}');
      }
    } on http.ClientException catch (e) {
      throw Exception('Ошибка сети: ${e.message}');
    } on TimeoutException catch (_) {
      throw Exception('Превышено время ожидания ответа от сервера');
    } catch (e) {
      throw Exception('Ошибка голосования: $e');
    }
  }
  
  /// Получение истории завершенных голосований
  Future<List<QuestionDetail>> getVotingHistory() async {
    try {
      final response = await _client
          .get(
            Uri.parse('$_baseUrl/api/voting/history'),
            headers: _getHeaders(),
          )
          .timeout(_timeout);

      return _handleResponse(
          response,
          (data) => (data as List)
              .map((json) => QuestionDetail.fromJson(json))
              .toList());
    } on http.ClientException catch (e) {
      throw Exception('Ошибка сети: ${e.message}');
    } on TimeoutException catch (_) {
      throw Exception('Превышено время ожидания ответа от сервера');
    } catch (e) {
      throw Exception('Ошибка получения истории голосований: $e');
    }
  }
  
  /// Проверка валидности токена
  bool get isAuthenticated => _token != null;
  
  /// Выход из системы
  void logout() {
    _token = null;
  }
  
  /// Закрытие клиента
  void dispose() {
    _client.close();
  }
}
