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
    final AuthScreenModel model = AuthScreenModelProvider.of(context)!;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.primary),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        obscureText: model.obscurePassword,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Пароль',
          hintStyle: TextStyle(color: colorScheme.onSurface),
          errorText:
              model.passwordError.isNotEmpty ? model.passwordError : null,
          errorStyle: TextStyle(color: colorScheme.error),
          suffixIcon: IconButton(
            icon: Icon(
              model.obscurePassword ? Icons.visibility_off : Icons.visibility,
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            onPressed: () => model.obscurePassword = !model.obscurePassword,
          ),
        ),
        onChanged: (value) => model.password = value,
      ),
    );
  }
}
