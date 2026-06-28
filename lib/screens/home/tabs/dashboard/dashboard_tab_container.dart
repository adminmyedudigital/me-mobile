import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:me_mobile/theme/theme.dart';
import 'package:me_mobile/screens/screens.dart';
import 'package:me_mobile/controllers/controllers.dart';

class DashboardTabContainer extends StatelessWidget {
  const DashboardTabContainer({super.key});

  Future<void> _pickDate(
    BuildContext context,
    DashboardController controller,
  ) async {
    final colors = context.colors;
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: controller.selectedDate.value,
      firstDate: DateTime(controller.today.value.year - 1),
      lastDate: DateTime(controller.today.value.year + 1, 12, 31),
      confirmText: isDarkTheme ? 'OK' : 'Select',
      cancelText: isDarkTheme ? 'Cancel' : 'Close',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: colors.accentOrange,
              onPrimary: colors.primaryOn,
              surface: colors.surfaceCard,
              onSurface: colors.ink,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: isDarkTheme ? colors.ink : colors.primary,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate == null) return;
    controller.selectDate(pickedDate);
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();

    return Obx(
      () => PlannerSurfaceContainer(
        title: controller.title,
        selectedDate: controller.selectedDate.value,
        today: controller.today.value,
        calendarView: controller.calendarView.value,
        events: controller.events,
        onPrevious: () => controller.moveDate(-1),
        onNext: () => controller.moveDate(1),
        onToday: controller.goToToday,
        onPickDate: () => _pickDate(context, controller),
        onViewChanged: controller.changeView,
        onDateSelected: controller.selectDate,
      ),
    );
  }
}
