import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SettingsDatabase {
  static const _boxName = 'settingsBox';
  static const _tokenKey = 'token';
  static const _encryptionKey = 'encryptionKey';

  
  static Future<void> _initBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      final secureStorage = FlutterSecureStorage();
      //Ключ, который шифрует box
      var encryptionKey = await secureStorage.read(key: _encryptionKey);
      if (encryptionKey == null) {
        encryptionKey = base64Encode(Hive.generateSecureKey());
        await secureStorage.write(key: _encryptionKey, value: encryptionKey);
      }
      await Hive.openBox<String>(
        _boxName,
        encryptionCipher: HiveAesCipher(base64Decode(encryptionKey)),
      );
    }
  }

  static Future<void> saveToken(String token) async {
    await _initBox();
    final box = Hive.box<String>(_boxName);
    await box.put(_tokenKey, token);
  }

  static Future<String?> getToken() async {
    await _initBox();
    final box = Hive.box<String>(_boxName);
    return box.get(_tokenKey);
  }

  static Future<void> deleteToken() async {
    await _initBox();
    final box = Hive.box<String>(_boxName);
    await box.delete(_tokenKey);
  }

  static void closeBox() {
    Hive.box(_boxName).close();
  }



  
}