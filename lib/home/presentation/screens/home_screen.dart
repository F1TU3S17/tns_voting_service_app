import 'package:flutter/material.dart';
import 'package:tns_voting_service_app/all_information/presentation/screens/info_screen.dart';
import 'package:tns_voting_service_app/all_information/domain/model/info_screen_model.dart';
import 'package:tns_voting_service_app/all_information/domain/state/info_screen_state.dart';
import 'package:tns_voting_service_app/core/global_widgets/gradient_appbar.dart';
import 'package:tns_voting_service_app/core/models/question_model.dart';
import 'package:tns_voting_service_app/home/domain/model/home_screen_model.dart';
import 'package:tns_voting_service_app/home/domain/state/home_screen_model_provider/home_screen_model_provider.dart';
import 'package:tns_voting_service_app/home/presentation/widgets/session_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.departmentName, required this.departmentId});
  final String departmentName;
  final String departmentId;
  @override
  State<HomePage> createState() => _HomePageState(departmentName, departmentId);
}

class _HomePageState extends State<HomePage> {
  final HomeScreenModel model = HomeScreenModel();
  final String departmentName;
  final String departmentId;
  _HomePageState(this.departmentName, this.departmentId);
  @override
  void initState() {
    super.initState();
    model.initQuestions(departmentId);
  }

  @override
  Widget build(BuildContext context) {
    return HomeScreenModelProvider(
      model: model,
      child: Builder(builder: (context) {
        final model = HomeScreenModelProvider.of(context)!.model;
        final theme = Theme.of(context);
        return Stack(children: [
          Scaffold(
            appBar: GradientAppBar(
              title: departmentName,
              fontSize: 14,
            ),
            body: RefreshIndicator(
              color: theme.iconTheme.color,
              onRefresh: () async {
                await model.initQuestions(departmentId);
              },
              child: ListView.builder(
                  itemCount: model.questions.length,
                  itemBuilder: (context, index) {
                    final List<QuestionShort> questions = model.questions;
                    return Stack(
                      clipBehavior: Clip.antiAlias,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 2.0, vertical: 4.0),
                          child: SessionCard(
                            title: questions[index].title,
                            description: questions[index].description,
                            sessionType: "Заочно",
                            votesInfo:
                                "Голоса: ${questions[index].votersCount}/${questions[index].votersTotal}",
                            date: questions[index].endDate,
                          ),
                        ),
                        Positioned.fill(
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) {
                                    final storyModel = InfoScreenModel(
                                        questions[index].endDate);
                                    return InfoScreenModelProvider(
                                      model: storyModel,
                                      child: InfoScreen(
                                        questionId: model.questions[index].id,
                                      ),
                                    );
                                  }),
                                );
                              },
                              customBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
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
