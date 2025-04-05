import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tns_voting_service_app/all_information/domain/state/info_screen_state.dart';
import 'package:tns_voting_service_app/all_information/presentation/widgets/buttoms_golos.dart';
import 'package:tns_voting_service_app/core/global_widgets/gradient_appbar.dart';
import 'package:tns_voting_service_app/core/utils/parse_date.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:open_file/open_file.dart';
import 'package:tns_voting_service_app/core/utils/open_ics_file.dart'; // Добавляем импорт
import 'package:tns_voting_service_app/core/entity/calendar_event.dart'; // Добавляем импорт

class InfoScreen extends StatefulWidget {
  final String questionId;

  const InfoScreen({super.key, required this.questionId});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  String? selectedOption;
  int? selectedOptionId;

  bool isFirstBuild = true;

  // Метод для открытия ссылки в браузере
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
        webViewConfiguration: const WebViewConfiguration(
          enableJavaScript: true,
          enableDomStorage: true,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Не удалось открыть ссылку')),
      );
    }
  }

  // Метод для добавления события в календарь
  Future<void> _addToCalendar(BuildContext context) async {
    try {
      final model = InfoScreenModelProvider.of(context)!.model;

      // Создаем событие календаря из данных вопроса
      final calendarEvent = CalendarEvent(
        title: model.questionDetail!.title,
        description: model.questionDetail!.description,
        startTime: model.questionDate!
            .subtract(Duration(hours: 1)), // Начало за час до окончания
        endTime: model.questionDate!, // Дата окончания голосования
        location: model.questionDetail?.conferenceLink ??
            "Онлайн", // Используем ссылку на конференцию если есть
      );

      // Используем нашу функцию для создания и открытия ICS-файла
      final result = await createAndOpenIcsForEvent(
        calendarEvent,
        context: context,
      );

      if (result) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Событие добавлено в календарь'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка при добавлении в календарь: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
      debugPrint('Ошибка добавления в календарь: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final model = InfoScreenModelProvider.of(context)!.model;
    selectedOption = model.getVoteTextByVoteId();

    // Определение цветов в зависимости от темы
    final isDark = theme.brightness == Brightness.dark;
    final backgroundColor = isDark ? theme.colorScheme.surface : Colors.white;
    final borderColor =
        isDark ? theme.colorScheme.primaryContainer : theme.colorScheme.primary;
    final cardColor = isDark ? theme.colorScheme.surfaceVariant : Colors.white;
    final textColor = isDark ? Colors.white : theme.colorScheme.onSurface;
    final dividerColor = isDark ? Colors.white24 : Colors.grey.shade300;

    if (isFirstBuild) {
      model.initQuestionDetail(widget.questionId);
      isFirstBuild = false;
    }
    return model.isLoading
        ? Scaffold(
            appBar: GradientAppBar(
              title: "Дететали по голосованию",
            ),
            body: Center(child: CircularProgressIndicator()))
        : Scaffold(
            appBar: GradientAppBar(
              title: model.questionDetail!.title,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 8, top: 20, right: 8, bottom: 16),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  alignment: Alignment.topCenter,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: borderColor,
                      width: 2.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Дата окончания
                        _buildInfoSection(
                          icon: Icons.event,
                          title: 'Дата окончания:',
                          value: parseDate(model.questionDate!),
                          textTheme: textTheme,
                          textColor: textColor,
                          iconColor: theme.colorScheme.secondary,
                        ),

                        const SizedBox(height: 12),

                        // Информация об участниках
                        _buildInfoSection(
                          icon: Icons.people,
                          title: 'Участники:',
                          value: model.questionDetail?.votingTypeText ?? '',
                          textTheme: textTheme,
                          textColor: textColor,
                          iconColor: theme.colorScheme.secondary,
                        ),

                        const SizedBox(height: 12),

                        // Тип принятия решения
                        _buildInfoSection(
                          icon: Icons.how_to_vote,
                          title: 'Тип принятия решения:',
                          value: model.questionDetail?.votingWayText ?? '',
                          textTheme: textTheme,
                          textColor: textColor,
                          iconColor: theme.colorScheme.secondary,
                        ),

                        const SizedBox(height: 12),

                        // Количество проголосовавших
                        _buildInfoSection(
                          icon: Icons.bolt,
                          title: 'Проголосовало:',
                          value:
                              '${model.questionDetail?.votersCount}/${model.questionDetail?.votersTotal}',
                          textTheme: textTheme,
                          textColor: textColor,
                          iconColor: theme.colorScheme.secondary,
                        ),

                        // Ссылка на конференцию, если она есть
                        if (model.questionDetail?.conferenceLink != null &&
                            model
                                .questionDetail!.conferenceLink.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          InkWell(
                            onTap: () => _launchURL(
                                model.questionDetail!.conferenceLink),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.videocam,
                                  color: theme.colorScheme.secondary,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Ссылка на конференцию:',
                                        style: textTheme.bodyMedium?.copyWith(
                                          color: textColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        model.questionDetail!.conferenceLink,
                                        style: textTheme.bodyMedium?.copyWith(
                                          color: theme.colorScheme.onSurface,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton.icon(
                            onPressed: () {
                              _addToCalendar(context);
                            },
                            icon: Icon(Icons.calendar_today, size: 18),
                            label: Text('Импортировать в календарь'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  theme.colorScheme.secondaryContainer,
                              foregroundColor:
                                  theme.colorScheme.onSecondaryContainer,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              textStyle: TextStyle(fontSize: 12),
                              visualDensity: VisualDensity.compact,
                            ),
                          ),
                        ],
                        Divider(color: dividerColor, thickness: 1),
                        const SizedBox(height: 12),

                        // Секция с прикрепленными файлами
                        if (model.questionDetail!.files.isNotEmpty) ...[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Прикрепленные файлы:',
                              style: textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: model.questionDetail!.files.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 8),
                            itemBuilder: (context, index) {
                              final file = model.questionDetail!.files[index];
                              return InkWell(
                                onTap: () async {
                                  try {
                                    // Показываем индикатор загрузки в виде диалога
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return Dialog(
                                          backgroundColor:
                                              theme.scaffoldBackgroundColor,
                                          child: Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                CircularProgressIndicator(),
                                                SizedBox(height: 16),
                                                Text('Загрузка файла...'),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );

                                    // Скачиваем файл
                                    final result = await model.downloadFile(
                                        file.id, file.name);

                                    // Закрываем диалог загрузки
                                    Navigator.of(context).pop();

                                    // Проверяем результат
                                    if (result.isEmpty) {
                                      throw Exception('Путь к файлу пустой');
                                    }

                                    // Проверяем существование файла
                                    final fileExists =
                                        await File(result).exists();
                                    if (!fileExists) {
                                      throw Exception(
                                          'Файл не найден: $result');
                                    }

                                    // Открываем файл с учетом особенностей платформы
                                    if (Platform.isIOS) {
                                      // На iOS иногда бывают проблемы с определенными символами в пути
                                      // Лучше использовать URL-кодирование для пути
                                      final fileUri = Uri.file(result);
                                      final openResult =
                                          await OpenFile.open(result);
                                      if (openResult.type != ResultType.done) {
                                        throw Exception(
                                            'Не удалось открыть файл: ${openResult.message}');
                                      }
                                    } else {
                                      // Для Android и других платформ
                                      final openResult =
                                          await OpenFile.open(result);
                                      if (openResult.type != ResultType.done) {
                                        throw Exception(
                                            'Не удалось открыть файл: ${openResult.message}');
                                      }
                                    }
                                  } catch (e) {
                                    // Закрываем диалог загрузки если он открыт
                                    if (Navigator.canPop(context)) {
                                      Navigator.of(context).pop();
                                    }

                                    // Показываем ошибку
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content:
                                            Text('Ошибка: ${e.toString()}'),
                                        backgroundColor: Colors.red,
                                        duration: Duration(seconds: 5),
                                      ),
                                    );

                                    // Для отладки выводим в консоль
                                    print('Ошибка при работе с файлом: $e');
                                  }
                                },
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    color: cardColor,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: dividerColor,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.picture_as_pdf,
                                        color: Colors.red,
                                        size: 24,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          file.name,
                                          style: textTheme.bodyMedium?.copyWith(
                                            color: textColor,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Icon(Icons.chevron_right,
                                          color: textColor),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          Divider(color: dividerColor, thickness: 1),
                          const SizedBox(height: 12),
                          Text(
                            'Описание:',
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 0),
                            child: Text(
                              model.questionDetail!.description,
                              style: textTheme.bodyLarge?.copyWith(
                                color: textColor,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Divider(color: dividerColor, thickness: 1),
                          const SizedBox(height: 12),
                          Text(
                            'Ваш голос:',
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    buildVoteButton(
                                      theme: theme,
                                      label: 'Поддержать',
                                      color: Colors.green,
                                      isSelected:
                                          selectedOption == 'Поддержать',
                                      onTap: () => setState(() {
                                        selectedOption = 'Поддержать';
                                        model.saveVoteOption(0);
                                      }),
                                    ),
                                    const SizedBox(height: 8),
                                    buildVoteButton(
                                      theme: theme,
                                      label: 'Воздержаться',
                                      color: Colors.orange,
                                      isSelected:
                                          selectedOption == 'Воздержаться',
                                      onTap: () => setState(() {
                                        selectedOption = 'Воздержаться';
                                        model.saveVoteOption(1);
                                      }),
                                    ),
                                    const SizedBox(height: 8),
                                    buildVoteButton(
                                      theme: theme,
                                      label: 'Против',
                                      color: Colors.red,
                                      isSelected: selectedOption == 'Против',
                                      onTap: () => setState(() {
                                        selectedOption = 'Против';
                                        model.saveVoteOption(2);
                                      }),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }

  // Виджет для отображения информационных секций
  Widget _buildInfoSection({
    required IconData icon,
    required String title,
    required String value,
    required TextTheme textTheme,
    required Color textColor,
    required Color iconColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: iconColor,
          size: 20,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: textTheme.bodyMedium?.copyWith(color: textColor),
              children: [
                TextSpan(
                  text: title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const TextSpan(text: ' '),
                TextSpan(text: value),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
