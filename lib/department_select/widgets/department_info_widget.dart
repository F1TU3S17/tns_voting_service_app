import 'package:flutter/material.dart';

class DepartmentInfoWidget extends StatelessWidget {
  const DepartmentInfoWidget({
    super.key,
    required this.name,
    required this.theme,
    required this.voteCount,
  });

  final String name;
  final ThemeData theme;
  final int voteCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: 4),
        Text(
          "Заседания: $voteCount",
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withAlpha(150),
          ),
        ),
      ],
    );
  }
}
