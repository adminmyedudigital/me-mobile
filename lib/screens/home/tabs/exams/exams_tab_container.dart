import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:me_mobile/theme/theme.dart';
import 'package:me_mobile/models/models.dart';
import 'package:me_mobile/routes/app_routes.dart';
import 'package:me_mobile/screens/screens.dart';
import 'package:me_mobile/controllers/controllers.dart';

class ExamsTabContainer extends StatelessWidget {
  const ExamsTabContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ExamsController>();

    return Obx(() {
      final content = _buildContent(context, controller);

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

  Widget _buildContent(BuildContext context, ExamsController controller) {
    if (controller.isDeletingExam.value) {
      return const ExamsTabLoading(message: 'Deleting exam result...');
    }

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
      onEdit: (exam) => _openEditForm(context, controller, exam),
      onDelete: (exam) => _confirmDelete(context, controller, exam.id),
      actionsEnabled: !controller.isApiOperationInProgress,
    );
  }

  Future<void> _openEditForm(
    BuildContext context,
    ExamsController controller,
    ExamModel exam,
  ) async {
    if (controller.isApiOperationInProgress) return;

    await controller.loadSubjectTopics();
    if (!context.mounted) return;

    Get.toNamed(AppRoutes.examResult, arguments: exam);
  }

  Future<void> _confirmDelete(
    BuildContext context,
    ExamsController controller,
    String examId,
  ) async {
    if (controller.isApiOperationInProgress) return;

    final confirmed = await showExamDeleteConfirmationDialog(context);
    if (!confirmed || !context.mounted) return;

    await controller.deleteExam(examId);
  }
}
