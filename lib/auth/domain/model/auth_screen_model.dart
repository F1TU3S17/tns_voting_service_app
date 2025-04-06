import 'package:flutter/material.dart';
import 'package:tns_voting_service_app/core/database/app_database.dart';
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
  bool _isLoading = false;
  bool _obscurePassword = true;

  String get login => _login;
  String get password => _password;
  String get loginError => _loginError;
  String get passwordError => _passwordError;
  bool get isLoading => _isLoading;
  bool get obscurePassword => _obscurePassword;

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

  set obscurePassword(bool value) {
    _obscurePassword = value;
    notifyListeners();
  }

  bool validate() {
    // Валидация логина
    if (login != 'admin' || password != 'password') {
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
      } else if (_password.length < 3) {
        _passwordError = 'Пароль слишком короткий (мин. 3 символов)';
      } else {
        _passwordError = '';
      }
    }
    notifyListeners();
    return _loginError.isEmpty && _passwordError.isEmpty;
  }

  Future<String> auth() async {
    _isLoading = true;
    notifyListeners();
    try {
      LoginResponse response = await repository.login(login, password);
      _isLoading = false;
      AppDatabase.saveToken(response.token);
      if (response.token.isEmpty) {
        _loginError = "Такого пользоваателя не существует";
        throw ("empty token exeption");
      }
      notifyListeners();
      return response.token;
    } catch (ex) {
      _loginError = "Такого пользоваателя не существует";
      print(ex);
      _isLoading = false;
      notifyListeners();
      return "";
    }
  }
}
