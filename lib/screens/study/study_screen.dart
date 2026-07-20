import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:me_mobile/theme/theme.dart';
import 'package:me_mobile/models/models.dart';
import 'package:me_mobile/routes/app_routes.dart';
import 'package:me_mobile/screens/study/study_practice_dialog.dart';

class StudyScreen extends StatelessWidget {
  const StudyScreen({super.key});

  Future<void> _choosePracticeTopic(
    BuildContext context, {
    required String title,
    required String route,
  }) async {
    final selection = await showDialog<StudyPracticeSelection>(
      context: context,
      builder: (context) => StudyPracticeDialog(title: title),
    );

    if (selection == null) {
      return;
    }

    Get.toNamed(route, arguments: selection);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Study')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.sm,
            AppSpacing.sm,
            AppSpacing.sm,
            AppSpacing.band,
          ),
          children: [
            Card(
              color: context.colors.surfaceElevated,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.school_outlined),
                    title: const Text('Academic Setup'),
                    subtitle: const Text(
                      'Setup your academic year, education board and class',
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Get.toNamed(AppRoutes.academicSetup),
                  ),
                  Divider(color: context.colors.hairline),
                  ListTile(
                    leading: const Icon(Icons.style_rounded),
                    title: const Text('Flash cards'),
                    subtitle: const Text('Practice and review study topics'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _choosePracticeTopic(
                      context,
                      title: 'Flash cards',
                      route: AppRoutes.flashCard,
                    ),
                  ),
                  Divider(color: context.colors.hairline),
                  ListTile(
                    leading: const Icon(Icons.quiz_rounded),
                    title: const Text('Quiz'),
                    subtitle: const Text('Test your understanding'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _choosePracticeTopic(
                      context,
                      title: 'Quiz',
                      route: AppRoutes.quiz,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
