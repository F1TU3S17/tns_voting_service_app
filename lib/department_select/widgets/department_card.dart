import 'package:flutter/material.dart';

class DepartmentCard extends StatelessWidget {
  final String name;
  final int voteCount;
  final String imageUrl;

  const DepartmentCard({
    super.key,
    required this.name,
    required this.voteCount,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: double.infinity,
          maxWidth: double.infinity,
        ),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {}, // обработка тапа если надо
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
              child: Row(
                children: [
                  // Заглушка под картинку
                  Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    child: Image.asset(
                      imageUrl,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Основной текст
                  Expanded(
                    child: Column(
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
                    ),
                  ),

                  // Стрелка вправо
                  Icon(
                    Icons.chevron_right,
                    color: theme.iconTheme.color?.withAlpha(180),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
