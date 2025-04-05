import 'package:flutter/material.dart';
import 'package:tns_voting_service_app/app/app_routes.dart';
import 'package:tns_voting_service_app/auth/domain/model/auth_screen_model.dart';
import 'package:tns_voting_service_app/core/database/app_database.dart';
import 'package:tns_voting_service_app/core/global_widgets/gradient_appbar.dart';

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
    final model = AuthScreenModel();
    final ThemeData theme = Theme.of(context);
    final List<ProfileMenuItem> menuItems = [
      ProfileMenuItem(
        icon: Icons.history,
        title: 'История голосований',
        onTap: () {
          Navigator.pushNamed(context, AppRoutes.voteStory);
        },
      ),
      ProfileMenuItem(
        icon: Icons.settings,
        title: 'Настройки',
        onTap: () {
          Navigator.pushNamed(context, AppRoutes.settings);
        },
      ),
      ProfileMenuItem(
        icon: Icons.logout,
        title: 'Выйти',
        onTap: () {
          Navigator.pushNamedAndRemoveUntil(
              context, AppRoutes.auth, (rou) => false);
          AppDatabase.deleteToken();
        },
      ),
    ];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: GradientAppBar(
        title: "Личный кабинет",
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileSection(context),
            _buildMenuSection(context, menuItems),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withAlpha(26),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: theme.primaryColor,
            child: Icon(
              Icons.person,
              size: 50,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Иванов Иван Иванович',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'ivaivaiva@tns.ru',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withAlpha(153),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection(
      BuildContext context, List<ProfileMenuItem> menuItems) {
    final ThemeData theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withAlpha(55),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: menuItems.length,
        separatorBuilder: (context, index) => Divider(
          height: 1,
          thickness: 1,
          indent: 16,
          endIndent: 16,
          color: theme.dividerColor.withAlpha(55),
        ),
        itemBuilder: (context, index) {
          final item = menuItems[index];
          return ListTile(
            leading: Icon(
              item.icon,
            ),
            title: Text(
              item.title,
              style: theme.textTheme.titleMedium,
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16,
            ),
            onTap: item.onTap,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            mouseCursor: SystemMouseCursors.click,
          );
        },
      ),
    );
  }
}
