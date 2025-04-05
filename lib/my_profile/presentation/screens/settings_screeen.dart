import 'package:flutter/material.dart';
import 'package:tns_voting_service_app/app/state/app_model_provider.dart';
import 'package:tns_voting_service_app/core/global_widgets/gradient_appbar.dart';
import 'package:tns_voting_service_app/my_profile/presentation/components/small_switch_list_tile.dart';

class SettingsScreeen extends StatefulWidget {
  const SettingsScreeen({super.key});

  @override
  State<SettingsScreeen> createState() => _SettingsScreeenState();
}

class _SettingsScreeenState extends State<SettingsScreeen> {
  bool notificationsEnabled = true;
  bool darkModeEnabled = false;
  String selectedLanguage = "Русский";
  bool biometricEnabled = false;
  
  @override
  Widget build(BuildContext context) {
    final appModel = AppModelProvider.of(context)!.appModel;
    final darkModeEnabled = appModel.isDarkTheme;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: GradientAppBar(title: "Настройки"),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSectionHeader(theme, "Основные"),
          _buildSettingsCard(
            children: [
              SmallSwitchListTile(
                title: Text("Тёмная тема", style: theme.textTheme.bodyMedium),
                subtitle: Text("Включить тёмный режим приложения", style: theme.textTheme.bodySmall),
                secondary: Icon(Icons.dark_mode),
                value: darkModeEnabled,
                onChanged: (value) async{
                    appModel.setAppTheme(value);
                },
              ),
              const Divider(),
              ListTile(
                leading: Icon(Icons.language),
                title: Text("Язык", style: theme.textTheme.bodyMedium),
                subtitle: Text("Выберите язык интерфейса", style: theme.textTheme.bodySmall),
                trailing: DropdownButton<String>(
                  value: selectedLanguage,
                  underline: Container(),
                  items: ["Русский", "English"].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        selectedLanguage = newValue;
                      });
                    }
                  },
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          _buildSectionHeader(theme, "Уведомления"),
          _buildSettingsCard(
            children: [
              SmallSwitchListTile(
                title: Text("Уведомления", style: theme.textTheme.bodyMedium),
                subtitle: Text("Получать уведомления о новых голосованиях", style: theme.textTheme.bodySmall),
                secondary: Icon(Icons.notifications),
                value: notificationsEnabled,
                onChanged: (value) {
                  setState(() {
                    notificationsEnabled = value;
                  });
                },
              ),
              if (notificationsEnabled) ... [
                const Divider(),
                CheckboxListTile(
                  title: Text("Новые голосования", style: theme.textTheme.bodyMedium),
                  subtitle: Text("Уведомлять при появлении новых голосований", style: theme.textTheme.bodySmall),
                  secondary: Icon(Icons.how_to_vote),
                  value: true,
                  onChanged: (value) {},
                ),
                const Divider(),
                CheckboxListTile(
                  title: Text("Результаты голосований", style: theme.textTheme.bodyMedium),
                  subtitle: Text("Уведомлять о публикации результатов", style: theme.textTheme.bodySmall),
                  secondary: Icon(Icons.insert_chart),
                  value: false,
                  onChanged: (value) {},
                ),
              ],
            ],
          ),
          
          const SizedBox(height: 24),
          _buildSectionHeader(theme, "Безопасность"),
          _buildSettingsCard(
            children: [
              SmallSwitchListTile(
                title: Text("Биометрическая аутентификация", style: theme.textTheme.bodyMedium),
                subtitle: Text("Использовать отпечаток пальца или Face ID для входа", style: theme.textTheme.bodySmall),
                secondary: Icon(Icons.fingerprint),
                value: biometricEnabled,
                onChanged: (value) {
                  setState(() {
                    biometricEnabled = value;
                  });
                },
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          _buildSectionHeader(theme, "О приложении"),
          _buildSettingsCard(
            children: [
              ListTile(
                leading: Icon(Icons.info_outline),
                title: Text("Версия приложения", style: theme.textTheme.bodyMedium),
                subtitle: Text("1.0.0", style: theme.textTheme.bodySmall),
              ),
              const Divider(),
              ListTile(
                leading: Icon(Icons.policy),
                title: Text("Политика конфиденциальности", style: theme.textTheme.bodyMedium),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
              const Divider(),
              ListTile(
                leading: Icon(Icons.help_outline),
                title: Text("Помощь", style: theme.textTheme.bodyMedium),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
            ],
          ),
          
          const SizedBox(height: 40),
        ],
      ),
    );
  }
  
  Widget _buildSectionHeader(ThemeData theme, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  
  Widget _buildSettingsCard({required List<Widget> children}) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

