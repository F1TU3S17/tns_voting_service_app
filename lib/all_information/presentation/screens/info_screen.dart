import 'package:flutter/material.dart';
import 'package:tns_voting_service_app/core/global_widgets/gradient_appbar.dart';
import 'package:tns_voting_service_app/core/models/question_model.dart';
import 'package:tns_voting_service_app/test_xuinia/simple-dimple.dart';
import 'package:tns_voting_service_app/theme/theme.dart';

class InfoScreen extends StatelessWidget {
  final QuestionShort question;

  const InfoScreen({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        gradient: AppTheme.defaultGradient,
        title: question.title,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  question.description,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
                Text(
                  "Голоса: ${question.votersCount}/${question.votersTotal}",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          // Просто стрелка без функционала
          const Positioned(
            right: 16,
            top: 100, // Фиксированная позиция
            child: SimpleVoteWidget(),
          ),
        ],
      ),
    );
  }
}
