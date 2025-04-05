import 'package:flutter/material.dart';
import 'package:tns_voting_service_app/core/global_widgets/gradient_appbar.dart';
import 'package:tns_voting_service_app/core/models/question_model.dart';
import 'package:tns_voting_service_app/core/utils/parse_date.dart';
import 'package:tns_voting_service_app/theme/theme.dart';
import 'package:tns_voting_service_app/all_information_story/presentation/widgets/buttoms_golos.dart';

class InfoStoryScreen extends StatefulWidget {
  final QuestionShort question;

  const InfoStoryScreen({super.key, required this.question});

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: GradientAppBar(
        gradient: AppTheme.defaultGradient,
        title: widget.question.title,
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
                          'Дата окончания: ${parseDate(widget.question.endDate)}',
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
                              'Проголосовало: ${widget.question.votersCount}/${widget.question.votersTotal}',
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
                      widget.question.description,
                      style: textTheme.bodyLarge,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  const SizedBox(height: 32),
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
                                        style: TextStyle(color: Colors.green),
                                      ),
                                      TextSpan(text: ' / '),
                                      TextSpan(
                                        text: '9%',
                                        style: TextStyle(color: Colors.orange),
                                      ),
                                      TextSpan(text: ' / '),
                                      TextSpan(
                                        text: '40%',
                                        style: TextStyle(color: Colors.red),
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
                              onTap: () =>
                                  setState(() => selectedOption = 'Поддержать'),
                            ),
                            const SizedBox(height: 8),
                            buildVoteButton(
                              label: 'Воздержаться',
                              color: Colors.orange,
                              isSelected: selectedOption == 'Воздержаться',
                              onTap: () => setState(
                                  () => selectedOption = 'Воздержаться'),
                            ),
                            const SizedBox(height: 8),
                            buildVoteButton(
                              label: 'Против',
                              color: Colors.red,
                              isSelected: selectedOption == 'Против',
                              onTap: () =>
                                  setState(() => selectedOption = 'Против'),
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
                              _buildTableHeader('Поддержали', Colors.green),
                              _buildTableHeader('Воздержались', Colors.orange),
                              _buildTableHeader('Против', Colors.red),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 150,
                          child: SingleChildScrollView(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildTableColumn(supporters),
                                _buildTableColumn(abstained),
                                _buildTableColumn(opposed),
                              ],
                            ),
                          ),
                        ),
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
