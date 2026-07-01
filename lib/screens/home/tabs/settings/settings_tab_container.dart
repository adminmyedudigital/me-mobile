import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:me_mobile/theme/theme.dart';
import 'package:me_mobile/routes/app_routes.dart';
import 'package:me_mobile/controllers/controllers.dart';

class SettingsTabContainer extends StatelessWidget {
  const SettingsTabContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xs,
        AppSpacing.xs,
        AppSpacing.xs,
        AppSpacing.band,
      ),
      children: [
        Card(
          color: context.colors.surfaceElevated,
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.style_rounded),
                title: const Text('Flash cards'),
                subtitle: const Text('Check you knowledge with flash cards'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
              Divider(color: context.colors.hairline),
              ListTile(
                leading: const Icon(Icons.quiz_rounded),
                title: const Text('Quiz'),
                subtitle: const Text('Check you knowledge with quiz'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
              Divider(color: context.colors.hairline),
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: const Text('Profile'),
                subtitle: const Text('Manage your account details'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Get.toNamed(AppRoutes.profile),
              ),

              Divider(color: context.colors.hairline),
              ListTile(
                leading: const Icon(Icons.person_pin_rounded),
                title: const Text('Change Username'),
                subtitle: const Text('Update your username'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Get.toNamed(AppRoutes.changeUsername),
              ),
              Divider(color: context.colors.hairline),
              ListTile(
                leading: const Icon(Icons.password_outlined),
                title: const Text('Change Password'),
                subtitle: const Text('Update your password'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Get.toNamed(AppRoutes.changePassword),
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
                  title: Text(
                    appController.isDarkMode ? 'Light mode' : 'Dark mode',
                  ),
                  subtitle: Text(
                    appController.isDarkMode
                        ? 'Using dark theme'
                        : 'Using light theme',
                  ),
                ),
              ),
              Divider(color: context.colors.hairline),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Sign out'),
                subtitle: const Text('Sign out of your account'),
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
