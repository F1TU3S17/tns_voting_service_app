import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AppDatabase {

  static const _tokenboxName = 'tokenBox';
  static const _boxName = 'appBox';
  static const _tokenKey = 'token';
  static const _encryptionKey = 'encryptionKey';

  
  static Future<void> _initTokenBox() async {
    if (!Hive.isBoxOpen(_tokenboxName)) {
      final secureStorage = FlutterSecureStorage();
      //Ключ, который шифрует box
      var encryptionKey = await secureStorage.read(key: _encryptionKey);
      if (encryptionKey == null) {
        encryptionKey = base64Encode(Hive.generateSecureKey());
        await secureStorage.write(key: _encryptionKey, value: encryptionKey);
      }
      await Hive.openBox<String>(
        _tokenboxName,
        encryptionCipher: HiveAesCipher(base64Decode(encryptionKey)),
      );
    }
  }

  static Future<void> _initAppBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox<bool>(_boxName);
    }
  }
  
  static Future<void> init() async {
    await Hive.initFlutter();
    await _initAppBox();
    await _initTokenBox();
  }

  static Future<void> saveToken(String token) async {
    await _initTokenBox();
    final box = Hive.box<String>(_tokenboxName);
    await box.put(_tokenKey, token);
  }

  static Future<String?> getToken() async {
    await _initTokenBox();
    final box = Hive.box<String>(_tokenboxName);
    return box.get(_tokenKey);
  }

  static Future<void> deleteToken() async {
    await _initTokenBox();
    final box = Hive.box<String>(_tokenboxName);
    await box.delete(_tokenKey);
  }

  static void closeBox() {
    Hive.box(_tokenboxName).close();
  }

  static Future<bool> getAppTheme() async {
    await _initAppBox();
    final box = Hive.box<bool>(_boxName);
    return box.get('theme', defaultValue: false)!;
  }

  static Future<void> setAppTheme(bool isDarkTheme) async {
    await _initAppBox();
    final box = Hive.box<bool>(_boxName);
    await box.put('theme', isDarkTheme);
  }

}