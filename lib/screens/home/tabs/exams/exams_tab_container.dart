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

    return Obx(() {
      final content = _buildContent(controller);

      return RefreshIndicator(
        color: context.colors.primary,
        backgroundColor: context.colors.surfaceCard,
        onRefresh: () async {
          await controller.refreshExams();
        },
        child: content,
      );
    });
  }

  Widget _buildContent(ExamsController controller) {
    if (controller.isLoadingExams.value) {
      return const ExamsTabLoading();
    }

    final errorMessage = controller.examsErrorMessage.value;
    if (errorMessage != null && controller.exams.isEmpty) {
      return ExamsTabNoData(
        icon: Icons.error_outline_rounded,
        message: errorMessage,
        onRetry: controller.loadExams,
      );
    }

    if (controller.exams.isEmpty) {
      return const ExamsTabNoData();
    }

    return ExamsTabList(
      exams: controller.sortedExams,
      dateFormatter: controller.formatDate,
    );
  }
}
