import 'package:flutter/material.dart';
import 'package:me_mobile/routes/app_routes.dart';
import 'package:me_mobile/theme/theme.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      children: [
        Text('Settings', style: context.textTheme.displaySmall),
        const SizedBox(height: AppSpacing.xxl),
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
                  Navigator.of(context).pushReplacementNamed(AppRoutes.signIn);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
