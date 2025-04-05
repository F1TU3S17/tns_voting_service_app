import 'package:flutter/material.dart';
import 'package:tns_voting_service_app/theme/theme.dart';

class GradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool automaticallyImplyLeading;
  final PreferredSizeWidget? bottom;
  final double elevation;
  final Gradient gradient;

  const GradientAppBar({
    super.key,
    this.title,
    this.automaticallyImplyLeading = true,
    this.bottom,
    this.elevation = 0,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title != null ? Text(title!, style: AppTheme.ligthTheme.textTheme.displaySmall) : null,
      actions: [Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset("assets/logoTNS.png"),
      )],
      automaticallyImplyLeading: automaticallyImplyLeading,
      bottom: bottom,
      elevation: elevation,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: gradient,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0.0));
}