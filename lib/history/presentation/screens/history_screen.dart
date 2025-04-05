import 'package:flutter/material.dart';
import 'package:tns_voting_service_app/all_information_story/domain/model/info_question_screen_model.dart';
import 'package:tns_voting_service_app/all_information_story/domain/state/info_story_screen_state.dart';
import 'package:tns_voting_service_app/all_information_story/presentation/screens/info_story_screen.dart';
import 'package:tns_voting_service_app/core/global_widgets/gradient_appbar.dart';
import 'package:tns_voting_service_app/core/models/question_model.dart';
import 'package:tns_voting_service_app/history/domain/model/history_screen_state.dart';
import 'package:tns_voting_service_app/history/domain/state/history_screen_model.dart';
import 'package:tns_voting_service_app/history/presentation/widgets/session_cards.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});
  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final HistoryScreenModel model = HistoryScreenModel();
  @override
  void initState() {
    super.initState();
    model.initQuestions();
  }

  @override
  Widget build(BuildContext context) {
    return HistoryScreenModelProvider(
      model: model,
      child: Builder(builder: (context) {
        final model = HistoryScreenModelProvider.of(context)!.model;
        final theme = Theme.of(context);
        return Stack(children: [
          Scaffold(
            appBar: GradientAppBar(
              title: "История",
            ),
            body: RefreshIndicator(
              color: theme.primaryColor,
              onRefresh: () async {
                await model.initQuestions();
              },
              child: ListView.builder(
                itemCount: model.questions.length,
                itemBuilder: (context, index) {
                  final List<QuestionShort> questions = model.questions;
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          final storyModel =
                              InfoStoryScreenModel(questions[index].endDate);
                          return InfoStoryScreenModelProvider(
                            model: storyModel,
                            child: InfoStoryScreen(
                              questionId: model.questions[index].id,
                            ),
                          );
                        }),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2.0, horizontal: 8.0),
                      child: SessionCard(
                        title: questions[index].title,
                        description: questions[index].description,
                        sessionType: "Заочно",
                        votesInfo:
                            "Голоса: ${questions[index].votersCount}/${questions[index].votersTotal}",
                        date: questions[index].endDate,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          if (model.isLoadind)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ]);
      }),
    );
  }
}
