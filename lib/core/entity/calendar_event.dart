import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class CalendarEvent {
  final String title;
  final String? description;
  final String? location;
  final DateTime startTime;
  final DateTime endTime;
  final String? uid; 
  final DateTime? dtStamp; 

  CalendarEvent({
    required this.title,
    this.description,
    this.location,
    required this.startTime,
    required this.endTime,
    this.uid,
    this.dtStamp,
  });
}

// Функция для форматирования DateTime в UTC формат iCalendar (YYYYMMDDTHHMMSSZ)
String formatIcsDateTime(DateTime dt) {
  // Используем intl для надежного форматирования в UTC
  // 'Z' в конце означает UTC
  return DateFormat("yyyyMMdd'T'HHmmss'Z'", 'en_US').format(dt.toUtc());
}

// Функция для экранирования специальных символов в тексте для .ics
String escapeIcsString(String text) {
  return text
      .replaceAll('\\', '\\\\') // Сначала экранируем сам бэкслеш
      .replaceAll(',', '\\,')
      .replaceAll(';', '\\;')
      .replaceAll('\n', '\\n'); // Новая строка
}

// Основная функция генерации содержимого .ics файла
String generateIcsContent(List<CalendarEvent> events, {String prodId = '-//MyDartApp//NONSGML Dart iCal Generator//EN'}) {
  final buffer = StringBuffer();
  final uuid = Uuid();

  buffer.writeln('BEGIN:VCALENDAR');
  buffer.writeln('VERSION:2.0');
  buffer.writeln('PRODID:$prodId');
  buffer.writeln('CALSCALE:GREGORIAN'); // Стандартный календарь

  for (final event in events) {
    buffer.writeln('BEGIN:VEVENT');

    // UID: Уникальный идентификатор события
    final eventUid = event.uid ?? uuid.v4();
    buffer.writeln('UID:$eventUid');

    // DTSTAMP: Время создания/модификации записи (сейчас, в UTC)
    final dtStamp = event.dtStamp ?? DateTime.now().toUtc();
    buffer.writeln('DTSTAMP:${formatIcsDateTime(dtStamp)}');

    // DTSTART/DTEND: Время начала и конца события (в UTC)
    buffer.writeln('DTSTART:${formatIcsDateTime(event.startTime)}');
    buffer.writeln('DTEND:${formatIcsDateTime(event.endTime)}');

    // SUMMARY: Название события
    buffer.writeln('SUMMARY:${escapeIcsString(event.title)}');

    // DESCRIPTION: Описание (если есть)
    if (event.description != null && event.description!.isNotEmpty) {
      buffer.writeln('DESCRIPTION:${escapeIcsString(event.description!)}');
    }

    // LOCATION: Место (если есть)
    if (event.location != null && event.location!.isNotEmpty) {
      buffer.writeln('LOCATION:${escapeIcsString(event.location!)}');
    }

    // STATUS: Статус события (можно добавить)
    buffer.writeln('STATUS:CONFIRMED'); // Или TENTATIVE, CANCELLED

    // SEQUENCE: Номер версии события (для обновлений)
    buffer.writeln('SEQUENCE:0'); // Начинаем с 0

    buffer.writeln('END:VEVENT');
  }

  buffer.writeln('END:VCALENDAR');

  return buffer.toString();
}