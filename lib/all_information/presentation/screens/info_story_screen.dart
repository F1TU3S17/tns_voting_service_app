import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tns_voting_service_app/all_information/domain/state/info_screen_state.dart';
import 'package:tns_voting_service_app/all_information/presentation/widgets/build_table_colomn.dart';
import 'package:tns_voting_service_app/all_information/presentation/widgets/build_table_header.dart';
import 'package:tns_voting_service_app/all_information/presentation/widgets/buttoms_golos.dart';
import 'package:tns_voting_service_app/all_information/presentation/widgets/color_for_grapf.dart';
import 'package:tns_voting_service_app/all_information/presentation/widgets/prevue-part.dart';
import 'package:tns_voting_service_app/core/global_widgets/gradient_appbar.dart';
import 'package:tns_voting_service_app/theme/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoStoryScreen extends StatefulWidget {
  final String questionId;
  const InfoStoryScreen({super.key, required this.questionId});

  @override
  State<InfoStoryScreen> createState() => _InfoStoryScreenState();
}

class _InfoStoryScreenState extends State<InfoStoryScreen> {
  String? selectedOption;
  int? selectedOptionId;
  List<String> supporters = [
    'Иванов И.',
    'Петров П.',
    'Сидоров С.',
    'Иванов И.',
    'Петров П.',
    'Сидоров С.',
    'Иванов И.',
    'Петров П.',
    'Сидоров С.',
    'Иванов И.',
    'Петров П.',
    'Сидоров С.'
  ];
  List<String> abstained = ['Смирнов С.', 'Кузнецов К.'];
  List<String> opposed = ['Васильев В.', 'Николаев Н.', 'Фёдоров Ф.'];

  Future<void> _openPdf(String assetPath) async {
    try {
      final byteData = await rootBundle.load(assetPath);
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/${assetPath.split('/').last}');
      await tempFile.writeAsBytes(byteData.buffer.asUint8List());

      if (await canLaunchUrl(Uri.file(tempFile.path))) {
        await launchUrl(Uri.file(tempFile.path));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Не удалось открыть файл')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка при открытии файла: $e')),
      );
    }
  }

  bool isFirstBuild = true;

  // Метод для открытия ссылки в браузере
 // Метод для открытия ссылки в браузере
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)){
      await launchUrl(uri);
    } 
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Не удалось открыть ссылку')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textTheme = theme.textTheme;
    final model = InfoScreenModelProvider.of(context)!.model;

    // Определение цветов в зависимости от темы
    final backgroundColor = isDark ? AppTheme.darkCardColor : theme.colorScheme.surface;
    final borderColor = isDark ? theme.colorScheme.primaryContainer : theme.colorScheme.primary;
    final cardColor = isDark ? AppTheme.darkCardColor : Colors.white;
    final textColor = isDark ? AppTheme.darkTextColor : Colors.black87;
    final dividerColor = isDark ? Colors.grey.shade800 : Colors.grey.shade300;

    // Получаем текущее значение голосования из модели
    selectedOption = model.getVoteTextByVoteId();

    if (isFirstBuild) {
      model.initQuestionDetail(widget.questionId);
      isFirstBuild = false;
    }

    return model.isLoading
        ? Scaffold(
            appBar: GradientAppBar(
              title: "Детали по голосованию",
            ),
            body: Center(
              child: CircularProgressIndicator(
                color: isDark
                    ? AppTheme.darkAccentColor
                    : theme.colorScheme.primary,
              ),
            ),
          )
        : Scaffold(
            appBar: GradientAppBar(
              title: model.questionDetail?.title,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 8, top: 20, right: 8, bottom: 16),
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
                        color: isDark
                            ? Colors.black.withOpacity(0.5)
                            : Colors.grey.withOpacity(0.3),
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
                        // Сохраняем использование PrevuePart компонента
                        PrevuePart(
                          context: context,
                          questionDate: model.questionDate!,
                          votersCount: model.questionDetail?.votersCount,
                          votersTotal: model.questionDetail?.votersTotal,
                          description: model.questionDetail?.description ?? '',
                        ),
                        
                        // Ссылка на конференцию, если она есть
                        if (model.questionDetail?.conferenceLink != null && 
                            model.questionDetail!.conferenceLink.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          InkWell(
                            onTap: () => _launchURL(model.questionDetail!.conferenceLink),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.videocam,
                                  color: isDark 
                                      ? AppTheme.darkAccentColor 
                                      : theme.colorScheme.secondary,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                          color: isDark
                                              ? AppTheme.darkAccentColor
                                              : theme.colorScheme.onSurface,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        
                        const SizedBox(height: 16),
                        Divider(color: dividerColor, thickness: 1),
                        const SizedBox(height: 12),
                        
                        // Секция с прикрепленными файлами
                        if (model.questionDetail!.files.isNotEmpty) ...[
                          Text(
                            'Прикрепленные файлы:',
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: textColor,
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
                                        color: isDark
                                            ? AppTheme.darkAccentColor
                                            : Colors.red,
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
                                      Icon(
                                        Icons.chevron_right,
                                        color: isDark
                                            ? AppTheme.darkSubtitleColor
                                            : Colors.grey,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          Divider(color: dividerColor, thickness: 1),
                          const SizedBox(height: 12),
                        ],
                        
                        // Заголовок для секции голосования
                        Text(
                          'Ваш голос:',
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Кнопки голосования и график
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildColoredPercentageText(),
                            Expanded(
                              child: Column(
                                children: [
                                  buildVoteButton(
                                    theme: theme,
                                    label: 'Поддержать',
                                    color: Colors.green,
                                    isSelected: selectedOption == 'Поддержать',
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
                        
                        const SizedBox(height: 16),
                        Divider(color: dividerColor, thickness: 1),
                        const SizedBox(height: 12),
                        
                        // Заголовок для таблицы результатов
                        Text(
                          'Результаты голосования:',
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 12),
                        
                        // Таблица с результатами голосования
                        Container(
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: dividerColor,
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: dividerColor,
                                      width: 1,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    buildTableHeader(
                                        'Поддержали', Colors.green),
                                    buildTableHeader(
                                        'Воздержались', Colors.orange),
                                    buildTableHeader('Против', Colors.red),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 150,
                                child: SingleChildScrollView(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      buildTableColumn(supporters),
                                      buildTableColumn(abstained),
                                      buildTableColumn(opposed),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
