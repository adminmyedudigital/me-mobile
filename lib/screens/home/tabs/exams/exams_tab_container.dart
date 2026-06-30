import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:me_mobile/theme/theme.dart';
import 'package:me_mobile/screens/screens.dart';
import 'package:me_mobile/controllers/controllers.dart';

class ExamsTabContainer extends StatelessWidget {
  const ExamsTabContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ExamsController>();

    return Obx(
      () => ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xs,
          AppSpacing.xs,
          AppSpacing.xs,
          AppSpacing.band,
        ),
        children: [
          for (final exam in controller.sortedExams) ...[
            ExamsTabCard(
              exam: exam,
              dateLabel: controller.formatDate(exam.examDate),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ],
      ),
    );
  }
}
