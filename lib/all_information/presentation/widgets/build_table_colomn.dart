import 'package:flutter/material.dart';
import 'package:tns_voting_service_app/theme/theme.dart';

Widget buildTableColumn(List<String> names) {
  List<String> supporters = [
    'Иванов И.',
    'Петров П.',
    'Сидоров С.',
    'Иванов И.',
    'Петров П.',
    'Сидоров С.',
    'Иванов И.',
    'Петров П.',
    'Сидоров С.',
    'Иванов И.',
    'Петров П.',
    'Сидоров С.'
  ];
  List<String> abstained = ['Смирнов С.', 'Кузнецов К.'];
  List<String> opposed = ['Васильев В.', 'Николаев Н.', 'Фёдоров Ф.'];
  return Builder(builder: (context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textTheme = theme.textTheme;
    return Expanded(
      child: Column(
        children: [
          for (var name in names)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(
                    color: Colors.transparent,
                    width: 1,
                  ),
                  bottom: BorderSide(
                    color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                    width: 1,
                  ),
                ),
              ),
              child: Text(
                name,
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  color: isDark ? AppTheme.darkTextColor : Colors.black87,
                ),
              ),
            ),
          if (names.length < supporters.length &&
              names.length < abstained.length &&
              names.length < opposed.length)
            for (var i = 0;
                i <
                    (supporters.length > abstained.length
                            ? supporters.length
                            : abstained.length) -
                        names.length;
                i++)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      color:
                          isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                      width: 1,
                    ),
                    bottom: BorderSide(
                      color:
                          isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  });
}
