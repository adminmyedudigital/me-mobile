import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:me_mobile/controllers/controllers.dart';
import 'package:me_mobile/enums/enums.dart';
import 'package:me_mobile/screens/home/tabs/dashboard/planner_surface/planner_surface_container.dart';
import 'package:me_mobile/theme/theme.dart';

part 'calendar/calendar_models.dart';
part 'calendar/calendar_detail_dialog.dart';
part 'calendar/calendar_views.dart';
part 'calendar/event_pill.dart';
part 'calendar/planner_surface.dart';

class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});

  Future<void> _pickDate(
    BuildContext context,
    DashboardController controller,
  ) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: controller.selectedDate.value,
      firstDate: DateTime(controller.today.value.year - 2),
      lastDate: DateTime(controller.today.value.year + 2, 12, 31),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: context.colors.accentGreen,
              onPrimary: context.colors.primaryOn,
              surface: context.colors.surfaceCard,
              onSurface: context.colors.ink,
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
      () => _PlannerSurface(
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
