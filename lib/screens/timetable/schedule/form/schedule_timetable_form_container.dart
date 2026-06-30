import 'package:flutter/material.dart';

import 'package:me_mobile/controllers/controllers.dart';
import 'package:me_mobile/screens/timetable/schedule/form/schedule_timetable_form.dart';

Future<void> showScheduleTimetableFormContainer(
  BuildContext context,
  ScheduleTimetableController controller, {
  ScheduleTimetableItem? item,
  DateTime? initialDate,
}) async {
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      return AnimatedPadding(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(sheetContext).bottom,
        ),
        child: ScheduleTimetableForm(
          parentContext: context,
          controller: controller,
          item: item,
          initialDate: initialDate,
        ),
      );
    },
  );
}
