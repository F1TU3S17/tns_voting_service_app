import 'package:flutter/material.dart';
import 'package:tns_voting_service_app/core/global_widgets/gradient_appbar.dart';

class ConfidentialPoliticScreen extends StatelessWidget {
  const ConfidentialPoliticScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: GradientAppBar(
          title: "Политика конфиденциальности",
          fontSize: 14,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  "Политика конфиденциальности и соглашение об использовании",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "1. Введение\nНаше приложение использует технологию блокчейн для создания безопасных и подлинных цифровых подписей. Мы защищаем ваши данные и обеспечиваем прозрачность работы системы.\n2. Какие данные мы собираем и как их защищаем\nМы собираем только необходимые данные: ваше имя, адрес электронной почты и публичный адрес в блокчейн-сети. Эти данные хранятся на защищенных серверах и используются для идентификации и проверки пользователей. Приватные ключи не хранятся на вашем устройстве — они генерируются и используются только на нашем сервере, что исключает риск их утраты или кражи.\n3. Как работает блокчейн для цифровых подписей\nБезопасность: Когда вы подписываете документ, мы создаем его хэш (уникальный цифровой отпечаток) и подписываем его с помощью приватного ключа на сервере. Приватный ключ никогда не передается на ваше устройство, что минимизирует риски утечки.\nНеизменность: Хэш документа и подпись записываются в блокчейн — децентрализованную сеть, где данные нельзя изменить или подделать.\nПроверка: Любой может проверить подлинность подписи, используя ваш публичный адрес и данные из блокчейна.\nСмарт-контракты: Специальная программа в блокчейне проверяет подпись, сравнивая адрес, восстановленный из подписи, с вашим публичным адресом. Если они совпадают, подпись действительна. Также смарт-контракт фиксирует время подписи, подтверждая, когда документ был подписан.\n4. Ваш публичный адрес в блокчейн-сети\nВаш публичный адрес — это уникальный идентификатор, связанный с вашим аккаунтом в приложении. Он используется для проверки ваших подписей и публично доступен в блокчейне. Мы приравниваем вас к этому адресу для обеспечения прозрачности и подлинности.\n5. Ваши права и обязанности\nВы должны защищать доступ к своему аккаунту (например, пароль или другие учетные данные).\nМы не храним ваш приватный ключ на устройстве, поэтому вам не нужно беспокоиться о его сохранности. Однако вы обязаны не передавать свои учетные данные третьим лицам.\n6. Кто за что отвечает\nМы: Отвечаем за безопасность данных на наших серверах и за правильную работу системы подписей в блокчейне.\nВы: Несете ответственность за безопасность своего аккаунта и конфиденциальность учетных данных.\n7. Изменения в политике\nЕсли мы обновим эту политику, вы узнаете об этом через email или уведомление в приложении.\n",
                  textAlign: TextAlign.justify,
                )
              ],
            ),
          ),
        ));
  }
}
