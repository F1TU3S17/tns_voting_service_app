import 'package:flutter/material.dart';
import 'package:tns_voting_service_app/auth/domain/model/auth_screen_model.dart';
import 'package:tns_voting_service_app/auth/domain/state/auth_state_model_provider.dart';

class LoginInputWidget extends StatelessWidget {
  const LoginInputWidget({
    super.key,
    required this.colorScheme,
  });

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    AuthScreenModel? model = AuthScreenModelProvider.of(context);
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.primary),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Логин',
          hintStyle:
              TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.6)),
          errorText: model!.loginError.isNotEmpty ? model.loginError : null,
          errorStyle: TextStyle(color: colorScheme.error),
        ),
        onChanged: (value) => model.login = value,
      ),
    );
  }
}
