import 'package:flutter/material.dart';
import 'package:tns_voting_service_app/core/global_widgets/gradient_appbar.dart';
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
    final ThemeData theme = Theme.of(context);
    final List<ProfileMenuItem> menuItems = [
      ProfileMenuItem(
        icon: Icons.history,
        title: 'История голосований',
        onTap: () {},
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
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: GradientAppBar(
        gradient: AppTheme.defaultGradient,
        title: "Личный кабинет",
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(context),
            _buildMenuSection(context, menuItems),
          ],
        ),
      ),
    );
  }
  
  Widget _buildProfileHeader(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      width: double.infinity, // Растягиваем на всю доступную ширину
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16), // Используем такие же отступы как в _buildMenuSection
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
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
            child: const Icon(
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
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildMenuSection(BuildContext context, List<ProfileMenuItem> menuItems) {
    final ThemeData theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
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
          color: Colors.grey.withOpacity(0.2),
        ),
        itemBuilder: (context, index) {
          final item = menuItems[index];
          return ListTile(
            leading: Icon(
              item.icon,
              color: theme.primaryColor,
            ),
            title: Text(
              item.title,
              style: theme.textTheme.titleMedium,
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey,
            ),
            onTap: item.onTap,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
