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
      appBar: GradientAppBar(
        gradient: AppTheme.defaultGradient,
        title: "Личный кабинет",
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
         
            child: Center(
              child: Column(
                children: [
                  Text('Иванов Иван Иванович',
                      style: TextStyle(
                        fontSize: 24,
                        color: const Color.fromARGB(255, 0, 0, 0),
                      )),
                  Text('ivaivaiva@tns.ru',
                      style: TextStyle(
                        fontSize: 16,
                        color: const Color.fromARGB(255, 0, 0, 0),
                      )),
                ],
              ),
            ),
          ),
          Container(
            height: 3,
            color: const Color.fromARGB(173, 76, 175, 79),
          ),
          Expanded(
            child: Container(
              child: ListView.separated(
                itemCount: menuItems.length,
                separatorBuilder: (context, index) => Container(
                  height: 1,
                  color: const Color.fromARGB(172, 1, 1, 1),
                ),
                itemBuilder: (context, index) {
                  final item = menuItems[index];
                  return ListTile(
                    leading: Icon(item.icon),
                    title: Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 18,
                        color: const Color.fromARGB(255, 0, 0, 0),
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
