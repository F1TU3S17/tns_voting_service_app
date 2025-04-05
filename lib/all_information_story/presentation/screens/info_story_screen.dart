import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tns_voting_service_app/all_information_story/domain/state/info_story_screen_state.dart';
import 'package:tns_voting_service_app/core/global_widgets/gradient_appbar.dart';
import 'package:tns_voting_service_app/all_information_story/presentation/widgets/buttoms_golos.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoStoryScreen extends StatefulWidget {
  //final QuestionShort question;
  final String questionId;
  const InfoStoryScreen({super.key, required this.questionId});

  @override
  State<InfoStoryScreen> createState() => _InfoStoryScreenState();
}

class _InfoStoryScreenState extends State<InfoStoryScreen> {
  String? selectedOption;
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
  //final model = InfoStoryScreenModel();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final model = InfoStoryScreenModelProvider.of(context)!.model;
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
              title: model.questionDetail?.title,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 8, top: 20, right: 8),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  alignment: Alignment.topCenter,
                  decoration: BoxDecoration(
                    color: theme.primaryColorLight,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: theme.colorScheme.primary,
                      width: 2.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: theme.canvasColor,
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
                                'Дата окончания: ',
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
                        ],
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              margin: const EdgeInsets.only(right: 20),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    width: 100,
                                    height: 100,
                                    child: CircularProgressIndicator(
                                      value: 1.0,
                                      strokeWidth: 10,
                                      color: Colors.grey[200],
                                      backgroundColor: Colors.transparent,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 100,
                                    height: 100,
                                    child: CircularProgressIndicator(
                                      value: 0.51,
                                      strokeWidth: 6,
                                      color: Colors.green,
                                      backgroundColor: Colors.transparent,
                                    ),
                                  ),
                                  Transform.rotate(
                                    angle: 0.51 * 2 * 3.1415926535,
                                    child: SizedBox(
                                      width: 100,
                                      height: 100,
                                      child: CircularProgressIndicator(
                                        value: 0.09,
                                        strokeWidth: 6,
                                        color: Colors.orange,
                                        backgroundColor: Colors.transparent,
                                      ),
                                    ),
                                  ),
                                  Transform.rotate(
                                    angle: (0.51 + 0.09) * 2 * 3.1415926535,
                                    child: SizedBox(
                                      width: 100,
                                      height: 100,
                                      child: CircularProgressIndicator(
                                        value: 0.40,
                                        strokeWidth: 6,
                                        color: Colors.red,
                                        backgroundColor: Colors.transparent,
                                      ),
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Голоса',
                                        style: textTheme.titleMedium,
                                      ),
                                      const SizedBox(height: 6),
                                      RichText(
                                        text: TextSpan(
                                          style: textTheme.bodySmall?.copyWith(
                                            color: theme.colorScheme.onSurface,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: '51%',
                                              style: TextStyle(
                                                  color: Colors.green),
                                            ),
                                            TextSpan(text: ' / '),
                                            TextSpan(
                                              text: '9%',
                                              style: TextStyle(
                                                  color: Colors.orange),
                                            ),
                                            TextSpan(text: ' / '),
                                            TextSpan(
                                              text: '40%',
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  buildVoteButton(
                                    label: 'Поддержать',
                                    color: Colors.green,
                                    isSelected: selectedOption == 'Поддержать',
                                    onTap: () => setState(
                                        () => selectedOption = 'Поддержать'),
                                  ),
                                  const SizedBox(height: 8),
                                  buildVoteButton(
                                    label: 'Воздержаться',
                                    color: Colors.orange,
                                    isSelected:
                                        selectedOption == 'Воздержаться',
                                    onTap: () => setState(
                                        () => selectedOption = 'Воздержаться'),
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
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey.shade300,
                                      width: 1,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    _buildTableHeader(
                                        'Поддержали', Colors.green),
                                    _buildTableHeader(
                                        'Воздержались', Colors.orange),
                                    _buildTableHeader('Против', Colors.red),
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
                                      _buildTableColumn(supporters),
                                      _buildTableColumn(abstained),
                                      _buildTableColumn(opposed),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }

  Widget _buildTableHeader(String title, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(
              color: Colors.transparent,
              width: 1,
            ),
          ),
        ),
        child: Text(
          title,
          textAlign: TextAlign.left,
          style: TextStyle(
            color: color,
          ),
        ),
      ),
    );
  }

  Widget _buildTableColumn(List<String> names) {
    return Expanded(
      child: Column(
        children: [
          for (var name in names)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(
                    color: Colors.transparent,
                    width: 1,
                  ),
                  bottom: BorderSide(
                    color: Colors.transparent,
                    width: 1,
                  ),
                ),
              ),
              child: Text(
                name,
                textAlign: TextAlign.center,
              ),
            ),
          if (names.length < supporters.length &&
              names.length < abstained.length &&
              names.length < opposed.length)
            for (var i = 0;
                i <
                    (supporters.length > abstained.length
                            ? supporters.length
                            : abstained.length) -
                        names.length;
                i++)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                    bottom: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
