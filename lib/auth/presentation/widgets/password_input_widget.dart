import 'package:flutter/material.dart';
import 'package:tns_voting_service_app/auth/domain/model/auth_screen_model.dart';
import 'package:tns_voting_service_app/auth/domain/state/auth_state_model_provider.dart';

class PasswordInputWidget extends StatelessWidget {
  const PasswordInputWidget({
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
        obscureText: true,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Пароль',
          hintStyle: TextStyle(color: colorScheme.onSurface),
          errorText:
              model!.passwordError.isNotEmpty ? model.passwordError : null,
          errorStyle: TextStyle(color: colorScheme.error),
        ),
        onChanged: (value) => model.password = value,
      ),
    );
  }
}
