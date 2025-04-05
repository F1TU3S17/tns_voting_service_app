import 'package:flutter/material.dart';
import 'package:tns_voting_service_app/app/models/app_model.dart';
import 'package:tns_voting_service_app/app/state/app_model_provider.dart';
import 'package:tns_voting_service_app/core/utils/get_current_theme.dart';
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
    return MaterialApp(
      theme: getCurrentTheme(appModel.isDarkTheme),
      home: const MainNavigation(),
      routes: ({
        '/settings': (context) => const SettingsScreeen(),
      }),
    );
  }
}

