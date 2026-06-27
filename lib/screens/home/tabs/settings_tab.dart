import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:me_mobile/theme/theme.dart';
import 'package:me_mobile/controllers/controllers.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.xs),
      children: [
        Card(
          child: Column(
            children: [
              SwitchListTile(
                value: true,
                onChanged: (_) {},
                secondary: const Icon(Icons.notifications_outlined),
                title: const Text('Notifications'),
                subtitle: const Text('Exam alerts and progress updates'),
              ),
              Divider(color: context.colors.hairline),
              Obx(
                () => SwitchListTile(
                  value: appController.isDarkMode,
                  onChanged: appController.toggleTheme,
                  secondary: Icon(
                    appController.isDarkMode
                        ? Icons.dark_mode_outlined
                        : Icons.light_mode_outlined,
                  ),
                  title: const Text('Dark mode'),
                  subtitle: Text(
                    appController.isDarkMode
                        ? 'Using dark theme'
                        : 'Using light theme',
                  ),
                ),
              ),
              Divider(color: context.colors.hairline),
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: const Text('Profile'),
                subtitle: const Text('Manage your account details'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
              Divider(color: context.colors.hairline),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Sign out'),
                onTap: () {
                  Get.find<AppController>().signOut();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
