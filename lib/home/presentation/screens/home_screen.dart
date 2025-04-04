import 'package:flutter/material.dart';
import 'package:tns_voting_service_app/core/global_widgets/gradient_appbar.dart';
import 'package:tns_voting_service_app/core/models/question_model.dart';
import 'package:tns_voting_service_app/home/domain/model/home_screen_model.dart';
import 'package:tns_voting_service_app/home/domain/state/home_screen_model_provider/home_screen_model_provider.dart';
import 'package:tns_voting_service_app/theme/theme.dart';
import 'package:tns_voting_service_app/home/presentation/widgets/session_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeScreenModel model = HomeScreenModel();
  @override
  void initState() {
    super.initState();
    model.initQuestions();
  }

  @override
  Widget build(BuildContext context) {
    return HomeScreenModelProvider(
      model: model, 
      child: Builder(
        builder: (context) {
          final model = HomeScreenModelProvider.of(context)!.model;
          final theme = Theme.of(context);
          return Stack(
            children:[
              Scaffold(
                appBar: GradientAppBar(
                  gradient: AppTheme.defaultGradient,
                  title: "Главная",
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
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
                        child: SessionCard(
                          title: questions[index].title,
                          description: questions[index].description,
                          sessionType: "Заочно",
                          votesInfo: "Голоса: ${questions[index].votersCount}/${questions[index].votersTotal}", 
                          date: questions[index].endDate,
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
                ]
            );
        }
      ),
    );
  }
}
