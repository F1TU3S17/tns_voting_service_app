import 'package:flutter/material.dart';
import 'package:tns_voting_service_app/theme/theme.dart';

Widget buildColoredPercentageText() {
  return Builder(
    builder: (context) {
      final theme = Theme.of(context);
      final isDark = theme.brightness == Brightness.dark;
      final textTheme = theme.textTheme;

      return Container(
        width: 100,
        height: 100,
        margin: const EdgeInsets.only(right: 20),
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: CircularProgressIndicator(
                value: 1.0,
                strokeWidth: 10,
                color: isDark ? Colors.grey.shade800 : Colors.grey[200],
                backgroundColor: Colors.transparent,
              ),
            ),
            SizedBox(
              width: 100,
              height: 100,
              child: CircularProgressIndicator(
                value: 0.51,
                strokeWidth: 6,
                color: Colors.green,
                backgroundColor: Colors.transparent,
              ),
            ),
            Transform.rotate(
              angle: 0.51 * 2 * 3.1415926535,
              child: SizedBox(
                width: 100,
                height: 100,
                child: CircularProgressIndicator(
                  value: 0.09,
                  strokeWidth: 6,
                  color: Colors.orange,
                  backgroundColor: Colors.transparent,
                ),
              ),
            ),
            Transform.rotate(
              angle: (0.51 + 0.09) * 2 * 3.1415926535,
              child: SizedBox(
                width: 100,
                height: 100,
                child: CircularProgressIndicator(
                  value: 0.40,
                  strokeWidth: 6,
                  color: Colors.red,
                  backgroundColor: Colors.transparent,
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Голоса',
                  style: textTheme.titleMedium?.copyWith(
                    color: isDark ? AppTheme.darkTextColor : Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                RichText(
                  text: TextSpan(
                    style: textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.surface,
                    ),
                    children: [
                      TextSpan(
                        text: '51%',
                        style: TextStyle(color: Colors.green),
                      ),
                      TextSpan(text: ' / '),
                      TextSpan(
                        text: '9%',
                        style: TextStyle(color: Colors.orange),
                      ),
                      TextSpan(text: ' / '),
                      TextSpan(
                        text: '40%',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
