import 'package:flutter/material.dart';
import 'package:tns_voting_service_app/core/global_widgets/gradient_appbar.dart';
import 'package:tns_voting_service_app/theme/theme.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        gradient: AppTheme.defaultGradient,
        title: "Личный кабинет",
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(top: 15, bottom: 25),
            child: Center(
              child: Column(
                children: [
                  Text('Иванов Иван Иванович',
                      style: TextStyle(
                        //fontWeight: FontWeight.bold,
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
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {},
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                child: Row(
                  spacing: 40,
                  children: [
                    Icon(Icons.history),
                    Text('История голосований',
                        style: TextStyle(
                          fontSize: 18,
                          color: const Color.fromARGB(255, 0, 0, 0),
                        )),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 70),
            child: Container(
              height: 1,
              color: const Color.fromARGB(172, 1, 1, 1),
            ),
          ),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {},
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                child: Row(
                  spacing: 40,
                  children: [
                    Icon(Icons.question_mark),
                    Text('Что-то',
                        style: TextStyle(
                          fontSize: 18,
                          color: const Color.fromARGB(255, 0, 0, 0),
                        )),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 70),
            child: Container(
              height: 1,
              color: const Color.fromARGB(172, 1, 1, 1),
            ),
          ),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {},
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                child: Row(
                  spacing: 40,
                  children: [
                    Icon(Icons.settings),
                    Text('Настройки',
                        style: TextStyle(
                          fontSize: 18,
                          color: const Color.fromARGB(255, 0, 0, 0),
                        )),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 70),
            child: Container(
              height: 1,
              color: const Color.fromARGB(172, 1, 1, 1),
            ),
          ),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {},
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                child: Row(
                  spacing: 40,
                  children: [
                    Icon(Icons.logout),
                    Text('Выйти',
                        style: TextStyle(
                          fontSize: 18,
                          color: const Color.fromARGB(255, 0, 0, 0),
                        )),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
