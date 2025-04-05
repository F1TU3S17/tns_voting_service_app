import 'package:flutter/material.dart';

abstract class AppTheme {
  static final LinearGradient gradientLigth = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFF00D921),
      Color(0xFF14BEEE),
    ],
  );
  // Цвета для темной темы
  static const Color darkPrimaryColor = Color(0xFF1F1F1F);
  static const Color darkSecondaryColor = Color(0xFF6FFF29);
  static const Color darkAccentColor = Color(0xff6fff29);
  static const Color darkBackgroundColor = Color(0xFF121212);
  static const Color darkCardColor = Color(0xFF252525);
  static const Color darkTextColor = Color(0xFFF5F5F5);
  static const Color darkSubtitleColor = Color(0xFFB0B0B0);


  static final LinearGradient gradientDark = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0x66000000), Color(0x661A1A40)],
  );

  static ThemeData ligthTheme = ThemeData(
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      primaryColor: Color(0xFF00E457),
      colorScheme: ColorScheme(
        primary: Color(0xFF00E457),
        onPrimary: Colors.white,
        secondary: Color(0xFF14BEEE),
        onSecondary: Colors.white,
        surface: Colors.white,
        onSurface: Colors.black87,
        error: Colors.red,
        onError: Colors.white,
        brightness: Brightness.light,
        
      ),
      iconTheme: IconThemeData(
        color: Color(0xFF14BEEE)
      ),
      scaffoldBackgroundColor: Color(0xFFE2E2E2),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
        indicatorColor: Color(0xFF00D921).withAlpha(55),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: WidgetStateProperty.all(TextStyle(
          color: Color(0xFF00E457),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        )),
        iconTheme: WidgetStateProperty.all(IconThemeData(
          color: Color(0xFF00E457),
        )),
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
        headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
        titleLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: Colors.black87,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: Colors.black87,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.black54,
        ),
        labelLarge: TextStyle(
          fontSize: 16,
          color: Color(0xFF00E457),
        ),
      ));

  static ThemeData darkTheme = ThemeData(
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
    iconTheme: IconThemeData(
      color: darkAccentColor,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return darkAccentColor;
        }
        return darkSubtitleColor;
      }),
      trackColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return darkAccentColor.withOpacity(0.5);
        }
        return darkCardColor;
      }),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return darkAccentColor;
        }
        return darkCardColor;
      }),
      checkColor: WidgetStateProperty.all(darkTextColor),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: darkTextColor),
      displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: darkTextColor),
      displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: darkTextColor),
      headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: darkTextColor),
      headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: darkTextColor),
      titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: darkTextColor),
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: darkTextColor),
      bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: darkTextColor),
      bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: darkSubtitleColor),
      labelLarge: TextStyle(fontSize: 16, color: darkAccentColor),
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
    navigationBarTheme: NavigationBarThemeData(
      indicatorColor: darkAccentColor,
      backgroundColor: darkPrimaryColor.withAlpha(25),
      elevation: 0,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: darkAccentColor,
    ),
  );
}
