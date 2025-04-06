import 'package:flutter/material.dart';
import 'package:tns_voting_service_app/core/global_widgets/gradient_appbar.dart';
import 'package:tns_voting_service_app/department_select/domain/state/department_model.dart';
import 'package:tns_voting_service_app/department_select/domain/state/department_model_provider.dart';
import 'package:tns_voting_service_app/department_select/widgets/department_card.dart';

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
          return Stack(
            children: [
              Scaffold(
                appBar: GradientAppBar(
                  title: "Выбор подразделения",
                ),
                body: ListView.builder(
                  itemCount: model?.departments.length ?? 0,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 2.0, vertical: 4.0),
                      child: DepartmentCard(
                        name: model!.departments[index].name,
                        voteCount: model.departments[index].voteCount,
                        imageUrl: 'assets/App_logo.png',
                      ),
                    );
                  },
                ),
              ),
              if (model!.isLoadind)
                SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
