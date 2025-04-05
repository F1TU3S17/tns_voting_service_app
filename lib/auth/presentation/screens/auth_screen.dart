import 'package:flutter/material.dart';
import 'package:tns_voting_service_app/auth/domain/model/auth_screen_model.dart';
import 'package:tns_voting_service_app/auth/domain/state/auth_state_model_provider.dart';
import 'package:tns_voting_service_app/auth/presentation/widgets/auth_button_widget.dart';
import 'package:tns_voting_service_app/auth/presentation/widgets/gosuslugi_auth_button_widget.dart';
import 'package:tns_voting_service_app/auth/presentation/widgets/login_input_widget.dart';
import 'package:tns_voting_service_app/auth/presentation/widgets/password_input_widget.dart';
import 'package:tns_voting_service_app/core/global_widgets/gradient_appbar.dart';
import 'package:tns_voting_service_app/theme/theme.dart';

class AuthorizationScreen extends StatelessWidget {
  AuthorizationScreen({super.key});
  final model = AuthScreenModel();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AuthScreenModelProvider(
      model: model,
      child: Scaffold(
        appBar: GradientAppBar(
          gradient: AppTheme.defaultGradient,
          title: "Авторизация",
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LoginInputWidget(colorScheme: colorScheme),
              const SizedBox(height: 16),
              PasswordInputWidget(colorScheme: colorScheme),
              const SizedBox(height: 24),
              AuthButtonWidget(colorScheme: colorScheme),
              const SizedBox(height: 24),
              GosuslugiAuthButton(colorScheme: colorScheme),
            ],
          ),
        ),
      ),
    );
  }
}
