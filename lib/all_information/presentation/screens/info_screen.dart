import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tns_voting_service_app/all_information/domain/state/info_screen_state.dart';
import 'package:tns_voting_service_app/all_information/presentation/widgets/buttoms_golos.dart';
import 'package:tns_voting_service_app/core/global_widgets/gradient_appbar.dart';
import 'package:tns_voting_service_app/core/utils/parse_date.dart';
import 'package:url_launcher/url_launcher.dart';

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
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final model = InfoScreenModelProvider.of(context)!.model;
    selectedOption = model.getVoteTextByVoteId();
    
    // Определение цветов в зависимости от темы
    final isDark = theme.brightness == Brightness.dark;
    final backgroundColor = isDark ? theme.colorScheme.surface : Colors.white;
    final borderColor = isDark ? theme.colorScheme.primaryContainer : theme.colorScheme.primary;
    final cardColor = isDark ? theme.colorScheme.surfaceVariant : Colors.white;
    final textColor = isDark ? Colors.white : theme.colorScheme.onSurface;
    final dividerColor = isDark ? Colors.white24 : Colors.grey.shade300;

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
                          value: '${model.questionDetail?.votersCount}/${model.questionDetail?.votersTotal}',
                          textTheme: textTheme,
                          textColor: textColor,
                          iconColor: theme.colorScheme.secondary,
                        ),
                        
                        const SizedBox(height: 16),
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
                                      Icon(Icons.chevron_right, color: textColor),
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
