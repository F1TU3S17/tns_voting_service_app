import 'package:flutter/material.dart';
import 'package:tns_voting_service_app/core/models/login_model.dart';
import 'package:tns_voting_service_app/core/repository/repository_provider.dart';
import 'package:tns_voting_service_app/core/repository/voting_repository.dart';

/// Модель данных для страницы авторизации.
class AuthScreenModel extends ChangeNotifier {
  /// Репозиторий для работы с авторизацией.
  final VotingRepository repository = RepositoryProvider.getRepository();
  String _login = "";
  String _password = "";
  String _loginError = "";
  String _passwordError = "";

  String get login => _login;
  String get password => _password;
  String get loginError => _loginError;
  String get passwordError => _passwordError;

  set login(String value) {
    _login = value;
    _loginError = ''; // Сбрасываем ошибку при изменении
    notifyListeners();
  }

  set password(String value) {
    _password = value;
    _passwordError = ''; // Сбрасываем ошибку при изменении
    notifyListeners();
  }

  bool validate() {
    // Валидация логина
    if (_login.isEmpty) {
      _loginError = 'Логин не может быть пустым';
    } else if (!_login.contains('@')) {
      _loginError = 'Некорректный формат логина';
    } else {
      _loginError = '';
    }

    // Валидация пароля
    if (_password.isEmpty) {
      _passwordError = 'Введите пароль';
    } else if (_password.length < 6) {
      _passwordError = 'Пароль слишком короткий (мин. 6 символов)';
    } else {
      _passwordError = '';
    }

    notifyListeners();
    return _loginError.isEmpty && _passwordError.isEmpty;
  }

  Future<String> auth() async {
    LoginResponse response = await repository.login(login, password);
    if (response.token.isEmpty) throw ("empty token exeption");
    return response.token;
  }
}
