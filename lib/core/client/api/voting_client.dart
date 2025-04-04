import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../../models/login_model.dart';
import '../../models/question_model.dart';
import '../../models/vote_model.dart';

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
  Future<File> downloadFile(String fileId, String savePath) async {
    try {
      final response = await _client
          .get(
            Uri.parse('$_baseUrl/api/files/$fileId'),
            headers: _getHeaders(),
          )
          .timeout(_timeout);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final file = File(savePath);
        await file.writeAsBytes(response.bodyBytes);
        return file;
      } else {
        if (response.statusCode == 404) {
          throw Exception('Файл не найден');
        } else if (response.statusCode == 401) {
          throw Exception('Токен недействителен');
        }
        throw Exception('Ошибка скачивания файла: ${response.statusCode}');
      }
    } on http.ClientException catch (e) {
      throw Exception('Ошибка сети: ${e.message}');
    } on TimeoutException catch (_) {
      throw Exception('Превышено время ожидания ответа от сервера');
    } catch (e) {
      throw Exception('Ошибка скачивания файла: $e');
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
