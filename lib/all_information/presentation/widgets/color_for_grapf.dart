import 'package:flutter/material.dart';
import 'package:tns_voting_service_app/theme/theme.dart';

Widget buildColoredPercentageText(
  final double? yep,
  final double? no,
  final double? maybe,
) {
  return Builder(
    builder: (context) {
      final theme = Theme.of(context);
      final isDark = theme.brightness == Brightness.dark;
      final textTheme = theme.textTheme;
      final yep100 = ((yep ?? 0) * 100).round();
      final no100 = ((no ?? 0) * 100).round();
      final maybe100 = ((maybe ?? 0) * 100).round();
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
                value: yep,
                strokeWidth: 6,
                color: Colors.green,
                backgroundColor: Colors.transparent,
              ),
            ),
            Transform.rotate(
              angle: yep! * 2.0 * 3.1415926535,
              child: SizedBox(
                width: 100,
                height: 100,
                child: CircularProgressIndicator(
                  value: maybe,
                  strokeWidth: 6,
                  color: Colors.orange,
                  backgroundColor: Colors.transparent,
                ),
              ),
            ),
            Transform.rotate(
              angle: (yep + maybe!) * 2 * 3.1415926535,
              child: SizedBox(
                width: 100,
                height: 100,
                child: CircularProgressIndicator(
                  value: no,
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
                        text: '${yep100}%',
                        style: TextStyle(color: Colors.green),
                      ),
                      TextSpan(text: '/'),
                      TextSpan(
                        text: '${maybe100}%',
                        style: TextStyle(color: Colors.orange),
                      ),
                      TextSpan(text: '/'),
                      TextSpan(
                        text: '${no100}%',
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
