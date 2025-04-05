import 'package:flutter/material.dart';

class DepartmentCard extends StatelessWidget {
  final String name;
  final int voteCount;

  const DepartmentCard({
    super.key,
    required this.name,
    required this.voteCount,
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
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: Row(
                children: [
                  // Заглушка под картинку
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child:
                        const Icon(Icons.image, size: 20, color: Colors.grey),
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
                            color: theme.brightness == Brightness.dark
                                ? const Color(0x99FFFFFF)
                                : const Color(0x99000000),
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
