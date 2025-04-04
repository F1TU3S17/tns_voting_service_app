import 'package:flutter/material.dart';
import 'package:tns_voting_service_app/core/global_widgets/gradient_appbar.dart';
import 'package:tns_voting_service_app/nav_bar/domain/state/navbar_model.dart';
import 'package:tns_voting_service_app/nav_bar/domain/state/navbar_model_provider.dart';
import 'package:tns_voting_service_app/theme/theme.dart';

class ProfileMenuItem {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });
}

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final NavbarModel model = NavbarModelProvider.of(context)!.model;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final List<ProfileMenuItem> menuItems = [
      ProfileMenuItem(
        icon: Icons.history,
        title: 'История голосований',
        onTap: () {
          model.changeItem(3);
        },
      ),
      ProfileMenuItem(
        icon: Icons.settings,
        title: 'Настройки',
        onTap: () {},
      ),
      ProfileMenuItem(
        icon: Icons.logout,
        title: 'Выйти',
        onTap: () {},
      ),
    ];

    return Scaffold(
      appBar: GradientAppBar(
        gradient: AppTheme.defaultGradient,
        title: "Личный кабинет",
      ),
      body: Column(
        children: [
          Container(
            color: colorScheme.surface,
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: Column(
                children: [
                  Text(
                    'Иванов Иван Иванович',
                    style: textTheme.headlineSmall?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'ivaivaiva@tns.ru',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 1,
            color: colorScheme.onSurface,
          ),
          Expanded(
            child: Container(
              //color: colorScheme.surface,
              child: ListView.separated(
                itemCount: menuItems.length,
                separatorBuilder: (context, index) => Divider(
                  height: 1,
                ),
                itemBuilder: (context, index) {
                  final item = menuItems[index];
                  return ListTile(
                    leading: Icon(
                      item.icon,
                      color: colorScheme.onSurface,
                    ),
                    title: Text(
                      item.title,
                      style: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                    onTap: item.onTap,
                    mouseCursor: SystemMouseCursors.click,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
