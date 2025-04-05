import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tns_voting_service_app/all_information/domain/state/info_screen_state.dart';
import 'package:tns_voting_service_app/core/global_widgets/gradient_appbar.dart';
import 'package:tns_voting_service_app/all_information_story/presentation/widgets/buttoms_golos.dart';
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

  bool isFirstBuild = true;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final model = InfoScreenModelProvider.of(context)!.model;
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
                padding: const EdgeInsets.only(left: 8, top: 20, right: 8),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  alignment: Alignment.topCenter,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: theme.colorScheme.primary,
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
                      children: [
                        Center(
                          child: Column(
                            children: [
                              Text(
                                'Дата окончания: ${parseDate(model.questionDate!)}',
                                style: textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.bolt,
                                    color: theme.colorScheme.secondary,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Проголосовало: ${model.questionDetail?.votersCount}/${model.questionDetail?.votersTotal}',
                                    style: textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurface,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        // Секция с прикрепленными файлами
                        if (model.questionDetail!.files.isNotEmpty) ...[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Прикрепленные файлы:',
                              style: textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
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
                              // final file = attachedFiles[index];
                              // final isPdf = file['path']!.endsWith('.pdf');

                              return InkWell(
                                //onTap: () => _openPdf(file['path']!),
                                //onTab: () =>
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Colors.grey.shade300,
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
                                          style: textTheme.bodyMedium,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const Icon(Icons.chevron_right),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 24),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 0),
                            child: Text(
                              model.questionDetail!.description,
                              style: textTheme.bodyLarge,
                              textAlign: TextAlign.left,
                            ),
                          ),
                          const SizedBox(height: 32),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    buildVoteButton(
                                      label: 'Поддержать',
                                      color: Colors.green,
                                      isSelected:
                                          selectedOption == 'Поддержать',
                                      onTap: () => setState(
                                          () => selectedOption = 'Поддержать'),
                                    ),
                                    const SizedBox(height: 8),
                                    buildVoteButton(
                                      label: 'Воздержаться',
                                      color: Colors.orange,
                                      isSelected:
                                          selectedOption == 'Воздержаться',
                                      onTap: () => setState(() =>
                                          selectedOption = 'Воздержаться'),
                                    ),
                                    const SizedBox(height: 8),
                                    buildVoteButton(
                                      label: 'Против',
                                      color: Colors.red,
                                      isSelected: selectedOption == 'Против',
                                      onTap: () => setState(
                                          () => selectedOption = 'Против'),
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
}
