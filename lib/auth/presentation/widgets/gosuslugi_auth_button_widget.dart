import 'package:flutter/material.dart';

class GosuslugiAuthButton extends StatelessWidget {
  const GosuslugiAuthButton({
    super.key,
    required this.colorScheme,
  });

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: colorScheme.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        onPressed: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/gosusl.png', width: 24, height: 24),
            const SizedBox(width: 8),
            const Text('Войти через Госуслуги'),
          ],
        ),
      ),
    );
  }
}
