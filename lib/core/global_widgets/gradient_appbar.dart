import 'package:flutter/material.dart';
import 'package:tns_voting_service_app/app/models/app_model.dart';
import 'package:tns_voting_service_app/app/state/app_model_provider.dart';
import 'package:tns_voting_service_app/theme/theme.dart';

class GradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool automaticallyImplyLeading;
  final PreferredSizeWidget? bottom;
  final double elevation;
  final double fontSize;

  const GradientAppBar({
    super.key,
    this.title,
    this.automaticallyImplyLeading = true,
    this.bottom,
    this.elevation = 0,
    this.fontSize = 24,
    // required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final AppModel appModel = AppModelProvider.of(context)!.appModel;
    final theme = Theme.of(context);
    final Gradient gradient =
        appModel.isDarkTheme ? AppTheme.gradientDark : AppTheme.gradientLigth;
    return AppBar(
      title: title != null
          ? Text(
              title!,
              style: theme.textTheme.displaySmall?.copyWith(fontSize: fontSize),
            )
          : null,
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset("assets/App_logo.png"),
        )
      ],
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
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0.0));
}
