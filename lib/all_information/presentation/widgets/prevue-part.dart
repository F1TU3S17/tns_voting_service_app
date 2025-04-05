import 'package:flutter/material.dart';
import 'package:tns_voting_service_app/core/utils/parse_date.dart';
import 'package:tns_voting_service_app/theme/theme.dart';

Widget PrevuePart({
  required BuildContext context,
  required DateTime? questionDate,
  required int? votersCount,
  required int? votersTotal,
  required String description,
}) {
  final theme = Theme.of(context);
  final textTheme = theme.textTheme;
  final isDark = theme.brightness == Brightness.dark;

  return Column(
    children: [
      Center(
        child: Column(
          children: [
            Text(
              'Дата окончания: ${parseDate(questionDate!)}',
              style: textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.bolt,
                  color: theme.colorScheme.secondary,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  'Проголосовало: $votersCount/$votersTotal',
                  style: textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      const SizedBox(height: 24),
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 0),
        child: Text(
          description,
          style: textTheme.bodyLarge?.copyWith(
            color: isDark ? AppTheme.darkTextColor : Colors.black87,
          ),
          textAlign: TextAlign.left,
        ),
      ),
    ],
  );
}
