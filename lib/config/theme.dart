import 'package:flutter/material.dart';

/// Класс, содержащий настройки тем приложения
class AppTheme {
  // Цвета для темной темы
  static const Color darkPrimaryColor = Color(0xFF1F1F1F);
  static const Color darkSecondaryColor = Color(0xFF2D2D2D);
  static const Color darkAccentColor = Color(0xFF6A42F4);
  static const Color darkBackgroundColor = Color(0xFF121212);
  static const Color darkCardColor = Color(0xFF252525);
  static const Color darkTextColor = Color(0xFFF5F5F5);
  static const Color darkSubtitleColor = Color(0xFFB0B0B0);
  
  // Градиенты для темной темы
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6A42F4), Color(0xFF8367F7)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [Color(0xFF423FE8), Color(0xFF6A42F4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFF6A42F4), Color(0xFF9D69FF)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Метод для получения темной темы
  static ThemeData getDarkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: darkPrimaryColor,
      scaffoldBackgroundColor: darkBackgroundColor,
      cardColor: darkCardColor,
      colorScheme: const ColorScheme.dark(
        primary: darkPrimaryColor,
        secondary: darkSecondaryColor,
        surface: darkCardColor,
        error: Colors.redAccent,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: darkPrimaryColor,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: darkTextColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: darkTextColor),
        displayMedium: TextStyle(color: darkTextColor),
        displaySmall: TextStyle(color: darkTextColor),
        headlineMedium: TextStyle(color: darkTextColor),
        headlineSmall: TextStyle(color: darkTextColor),
        titleLarge: TextStyle(color: darkTextColor),
        titleMedium: TextStyle(color: darkTextColor),
        titleSmall: TextStyle(color: darkTextColor),
        bodyLarge: TextStyle(color: darkTextColor),
        bodyMedium: TextStyle(color: darkTextColor),
        bodySmall: TextStyle(color: darkSubtitleColor),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkAccentColor,
          foregroundColor: darkTextColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}

/// Утилиты для работы с градиентами
class GradientUtils {
  // Виджет с градиентным фоном
  static Widget gradientContainer({
    required Widget child,
    required LinearGradient gradient,
    EdgeInsetsGeometry padding = EdgeInsets.zero,
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(8)),
  }) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: borderRadius,
      ),
      child: child,
    );
  }
  
  // Градиентная кнопка
  static Widget gradientButton({
    required String text,
    required VoidCallback onPressed,
    LinearGradient gradient = AppTheme.primaryGradient,
    double borderRadius = 8.0,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
  }) {
    return InkWell(
      onTap: onPressed,
      child: gradientContainer(
        gradient: gradient,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Padding(
          padding: padding,
          child: Text(
            text,
            style: const TextStyle(
              color: AppTheme.darkTextColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
