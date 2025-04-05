import 'package:flutter/material.dart';

/// Кастомный виджет для уменьшенного переключателя
class SmallSwitchListTile extends StatelessWidget {
  final Widget title;
  final Widget? subtitle;
  final Widget? secondary;
  final bool value;
  final ValueChanged<bool>? onChanged;
  
  const SmallSwitchListTile({
    Key? key,
    required this.title,
    this.subtitle,
    this.secondary,
    required this.value,
    required this.onChanged,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: title,
      subtitle: subtitle,
      secondary: secondary,
      value: value,
      onChanged: onChanged,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      // Уменьшаем размер переключателя
      controlAffinity: ListTileControlAffinity.trailing,
      dense: true,
      inactiveThumbColor: Theme.of(context).disabledColor,
    );
  }
}