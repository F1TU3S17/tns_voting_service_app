import 'package:flutter/material.dart';
import 'package:tns_voting_service_app/app/app_routes.dart';
import 'package:tns_voting_service_app/app/models/app_model.dart';
import 'package:tns_voting_service_app/app/state/app_model_provider.dart';
import 'package:tns_voting_service_app/auth/presentation/screens/auth_screen.dart';
import 'package:tns_voting_service_app/core/global_widgets/gradient_appbar.dart';
import 'package:tns_voting_service_app/core/utils/get_current_theme.dart';
import 'package:tns_voting_service_app/department_select/presentation/department_select_screen.dart';
import 'package:tns_voting_service_app/history/presentation/screens/history_screen.dart';
import 'package:tns_voting_service_app/home/presentation/screens/home_screen.dart';
import 'package:tns_voting_service_app/my_profile/presentation/screens/settings_screeen.dart';
import 'package:tns_voting_service_app/nav_bar/presentation/widgets/main_navigation.dart';

class TnsApp extends StatelessWidget {
  TnsApp({super.key});
  final appModel = AppModel();

  @override
  Widget build(BuildContext context) {
    return AppModelProvider(
      appModel: AppModel(),
      child: AppCore(),
    );
  }
}

class AppCore extends StatelessWidget {
  const AppCore({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final appModel = AppModelProvider.of(context)!.appModel;
    final token = appModel.token;
    return appModel.isLoading
        ? MaterialApp(
            theme: getCurrentTheme(appModel.isDarkTheme),
            home: Scaffold(
              appBar: GradientAppBar(),
              body: SizedBox(
                height: double.infinity,
                width: double.infinity,
              ),
            ),
          )
        : MaterialApp(
            theme: getCurrentTheme(appModel.isDarkTheme),
            home: token == null ? AuthorizationScreen() : MainNavigation(),
            routes: ({
              AppRoutes.settings: (context) => const SettingsScreeen(),
              AppRoutes.auth: (context) => AuthorizationScreen(),
              AppRoutes.voteStory: (context) => const HistoryPage(),
              AppRoutes.main: (context) => const MainNavigation(),
              AppRoutes.departmentSelect: (context) => DepartmentSelectScreen(),
              AppRoutes.voteList: (context) {
                final departmentName =
                    ModalRoute.of(context)!.settings.arguments as String;
                return HomePage(departmentName: departmentName);
              },
            }),
          );
  }
}
