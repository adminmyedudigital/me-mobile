import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:me_mobile/theme/theme.dart';
import 'package:me_mobile/screens/screens.dart';
import 'package:me_mobile/controllers/controllers.dart';
import 'package:me_mobile/widgets/widgets.dart';

class ScheduleTimetable extends StatelessWidget {
  const ScheduleTimetable({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ScheduleTimetableController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Schedule time table')),
      body: SafeArea(
        child: Obx(
          () => ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.xs,
              AppSpacing.xs,
              AppSpacing.xs,
              AppSpacing.band,
            ),
            children: [
              ScheduleWeekHeader(),
              const SizedBox(height: AppSpacing.sm),
              ScheduleSummaryStrip(),
              const SizedBox(height: AppSpacing.lg),
              for (final date in controller.weekDays) ...[
                ScheduleDaySection(
                  date: date,
                  items: controller.itemsForDate(date),
                  controller: controller,
                  onAdd: () => showScheduleTimetableFormContainer(
                    context,
                    controller,
                    initialDate: date,
                  ),
                  onEdit: (item) => showScheduleTimetableFormContainer(
                    context,
                    controller,
                    item: item,
                  ),
                  onDelete: controller.deleteItem,
                  canAdd: controller.canScheduleDate(date),
                ),
                const SizedBox(height: AppSpacing.sm),
              ],
              MEButton(
                fullWidth: true,
                onPressed: () {},
                icon: Icons.save,
                label: 'Save plan',
                backgroundColor: context.colors.primary,
                foregroundColor: context.colors.surfaceCard,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add study plan',
        onPressed: () =>
            showScheduleTimetableFormContainer(context, controller),
        child: const Icon(Icons.add_rounded, size: 30),
      ),
    );
  }
}
