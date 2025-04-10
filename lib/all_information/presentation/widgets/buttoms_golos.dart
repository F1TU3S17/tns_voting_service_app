import 'package:flutter/material.dart';

Widget buildVoteButton({
  required ThemeData theme,
  required String label,
  required Color color,
  required bool isSelected,
  required VoidCallback onTap,
}) {
  return SizedBox(
    width: double.infinity,
    child: TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        alignment: Alignment.centerLeft,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        backgroundColor:
            isSelected ? color.withValues(alpha: 0.2) : Colors.transparent,
      ),
      onPressed: onTap,
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? color : null,
              border: Border.all(
                color: isSelected
                    ? color
                    : const Color.fromARGB(255, 158, 158, 158),
              ),
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? color : theme.colorScheme.onSurface,
              fontSize: 14,
            ),
          ),
        ],
      ),
    ),
  );
}
