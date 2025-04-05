import 'package:flutter/material.dart';
import 'package:tns_voting_service_app/core/global_widgets/gradient_appbar.dart';
import 'package:tns_voting_service_app/core/models/department_model.dart';
import 'package:tns_voting_service_app/core/repository/repository_provider.dart';
import 'package:tns_voting_service_app/core/repository/voting_repository.dart';
import 'package:tns_voting_service_app/department_select/state/department_model.dart';
import 'package:tns_voting_service_app/department_select/state/department_model_provider.dart';
import 'package:tns_voting_service_app/department_select/widgets/department_card.dart';
import 'package:tns_voting_service_app/home/domain/model/home_screen_model.dart';
import 'package:tns_voting_service_app/home/domain/state/home_screen_model_provider/home_screen_model_provider.dart';

class DepartmentSelectScreen extends StatefulWidget {
  DepartmentSelectScreen({super.key});

  @override
  State<DepartmentSelectScreen> createState() => _DepartmentSelectScreenState();
}

class _DepartmentSelectScreenState extends State<DepartmentSelectScreen> {
  final DepartmentModel model = DepartmentModel();
  @override
  void initState() {
    super.initState();
    model.initDepartments();
  }

  @override
  Widget build(BuildContext context) {
    return DepartmentModelProvider(
      model: model,
      child: Builder(
        builder: (BuildContext context) {
          final model = DepartmentModelProvider.of(context);
          final theme = Theme.of(context);
          return Scaffold(
            appBar: GradientAppBar(
              title: "Выбор подразделения",
            ),
            body: ListView.builder(
              itemCount: model?.departments.length ?? 0,
              itemBuilder: (context, index) {
                return Stack(
                  clipBehavior: Clip.antiAlias,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 2.0, vertical: 4.0),
                      child: DepartmentCard(
                        name: model!.departments[index].name,
                        voteCount: model.departments[index].voteCount,
                      ),
                    ),
                    Positioned.fill(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(builder: (context) {
                            //     final storyModel =
                            //         InfoScreenModel(questions[index].endDate);
                            //     return InfoScreenModelProvider(
                            //       model: storyModel,
                            //       child: InfoScreen(
                            //         questionId: model.questions[index].id,
                            //       ),
                            //     );
                            //   }),
                            // );
                          },
                          customBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
