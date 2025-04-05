import 'package:flutter/material.dart';
import 'package:tns_voting_service_app/core/global_widgets/gradient_appbar.dart';
import 'package:tns_voting_service_app/core/models/question_model.dart';
import 'package:tns_voting_service_app/core/utils/parse_date.dart';
import 'package:tns_voting_service_app/theme/theme.dart';
import 'package:tns_voting_service_app/all_information_story/presentation/widgets/buttoms_golos.dart';

class InfoScreen extends StatefulWidget {
  final QuestionShort question;

  const InfoScreen({super.key, required this.question});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  String? selectedOption;

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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
