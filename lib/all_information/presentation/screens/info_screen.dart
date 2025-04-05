import 'package:flutter/material.dart';
import 'package:tns_voting_service_app/core/global_widgets/gradient_appbar.dart';
import 'package:tns_voting_service_app/core/models/question_model.dart';
import 'package:tns_voting_service_app/theme/theme.dart';

class InfoScreen extends StatelessWidget {
  final QuestionShort question;

  const InfoScreen({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: GradientAppBar(
        gradient: AppTheme.defaultGradient,
        title: question.title,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(40.0),
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
                            'Дата окончания: ${question.endDate}',
                            style: textTheme.bodySmall?.copyWith(
                              color:
                                  theme.colorScheme.onSurface.withOpacity(0.7),
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
                                'Проголосовало: ${question.votersCount}/${question.votersTotal}',
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
                        question.description,
                        style: textTheme.bodyLarge,
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
