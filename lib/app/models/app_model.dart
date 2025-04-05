import 'package:flutter/material.dart';
import 'package:tns_voting_service_app/core/database/app_database.dart';

class AppModel extends ChangeNotifier {
  /// Состояние загрузки данных.
  ///
  /// `true` - данные загружаются, `false` - загрузка завершена.
  bool isLoading = true;
  bool isDarkTheme = false;

  AppModel() {
    init();
  }

  /// Инициализация модели приложения.
  ///
  /// Устанавливает состояние загрузки в `true`, затем выполняет необходимые операции и устанавливает состояние загрузки в `false`.
  Future<void> init() async{
    isLoading = true;
    
    await getCurrentTheme();

    notifyListeners();
    isLoading = false;
  }

  Future<void> getCurrentTheme() async{
    AppDatabase.getAppTheme().then((value) {
      isDarkTheme = value;
      notifyListeners();
    });
  }

  /// Установка темы приложения.
  Future<void> setAppTheme(bool isDarkTheme) async {
    this.isDarkTheme = isDarkTheme;
    await AppDatabase.setAppTheme(isDarkTheme);
    notifyListeners();
  }


}