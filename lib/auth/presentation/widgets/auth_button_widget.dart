import 'package:flutter/material.dart';
import 'package:tns_voting_service_app/app/app_routes.dart';
import 'package:tns_voting_service_app/auth/domain/model/auth_screen_model.dart';
import 'package:tns_voting_service_app/auth/domain/state/auth_state_model_provider.dart';

// ignore: must_be_immutable
class AuthButtonWidget extends StatelessWidget {
  AuthButtonWidget({
    super.key,
    required this.colorScheme,
  });

  final ColorScheme colorScheme;
  late String token;

  @override
  Widget build(BuildContext context) {
    AuthScreenModel? model = AuthScreenModelProvider.of(context);
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        onPressed: () async {
          if (model!.validate()) {
            try {
              token = await model.auth();
              if (token.isNotEmpty)
                Navigator.popAndPushNamed(context, AppRoutes.main);
            }
            // что-то придумать
            catch (ex) {
              print(ex);
            }
          }
        },
        child: Text(
          'Войти',
          style: TextStyle(
            color: colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
