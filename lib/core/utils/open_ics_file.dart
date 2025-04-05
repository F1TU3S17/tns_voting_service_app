import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:tns_voting_service_app/core/entity/calendar_event.dart' as event_lib;
import 'package:tns_voting_service_app/core/utils/parse_ics_datetime.dart';

/// Создает ICS-файл из строки содержимого и открывает его
/// [icsContent] - строка с содержимым ICS-файла
/// [fileName] - имя файла, по умолчанию "event.ics"
/// [context] - контекст для показа диалогов (опционально)
Future<bool> createAndOpenIcsFile(
  String icsContent, {
  String fileName = "event.ics",
  BuildContext? context,
}) async {
  try {
    // Показываем индикатор загрузки, если передан контекст
    if (context != null) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Подготовка календаря...'),
                ],
              ),
            ),
          );
        },
      );
    }

    // Получаем временную директорию
    final Directory tempDir = await getTemporaryDirectory();
    
    // Удаляем запрещенные символы из имени файла
    final String sanitizedFileName = fileName
        .replaceAll(RegExp(r'[\\/:*?"<>|]'), '_')
        .endsWith('.ics') ? fileName : '$fileName.ics';

    // Создаем путь к файлу
    final String filePath = '${tempDir.path}/$sanitizedFileName';
    
    // Создаем и записываем файл
    final File file = File(filePath);
    await file.writeAsString(icsContent);
    
    // Проверяем, что файл создан
    if (!await file.exists()) {
      throw Exception('Не удалось создать файл: $filePath');
    }
    
    // Закрываем диалог загрузки, если он был показан
    if (context != null && Navigator.canPop(context)) {
      Navigator.of(context).pop();
    }
    
    // Открываем файл с учетом особенностей платформы
    final OpenResult result;
    result = await OpenFile.open(filePath);
   
    // Проверяем результат открытия
    if (result.type != ResultType.done) {
      throw Exception('Не удалось открыть файл: ${result.message}');
    }
    
    return true;
  } catch (e) {
    // Закрываем диалог загрузки, если он открыт
    if (context != null && Navigator.canPop(context)) {
      Navigator.of(context).pop();
    }
    
    // Показываем ошибку
    if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5),
        ),
      );
    }
    
    // Выводим ошибку в консоль для отладки
    debugPrint('Ошибка при работе с ICS-файлом: $e');
    return false;
  }
}

/// Создает ICS-файл из событий календаря и открывает его
/// [events] - список событий календаря
/// [fileName] - имя файла, по умолчанию "calendar.ics"
/// [context] - контекст для показа диалогов (опционально)
Future<bool> createAndOpenIcsFromEvents(
  List<event_lib.CalendarEvent> events, {
  String fileName = "calendar.ics",
  BuildContext? context,
}) async {
  // Генерируем содержимое ICS из событий
  final String icsContent = generateIcsContent(events);
  
  // Создаем и открываем файл
  return createAndOpenIcsFile(
    icsContent,
    fileName: fileName,
    context: context,
  );
}

/// Создает и открывает ICS-файл для одного события
/// [event] - событие календаря
/// [fileName] - имя файла, по умолчанию "event.ics"
/// [context] - контекст для показа диалогов (опционально)
Future<bool> createAndOpenIcsForEvent(
  event_lib.CalendarEvent event, {
  String? fileName,
  BuildContext? context,
}) async {
  // Генерируем имя файла из названия события, если не указано
  final String eventFileName = fileName ?? 
      '${event.title.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_').substring(0, 
          event.title.length > 20 ? 20 : event.title.length)}.ics';
  
  // Создаем и открываем файл для одного события
  return createAndOpenIcsFromEvents(
    [event],
    fileName: eventFileName,
    context: context,
  );
}
