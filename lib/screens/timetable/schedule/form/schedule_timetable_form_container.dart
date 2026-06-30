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
      return ScheduleTimetableForm(
        parentContext: context,
        controller: controller,
        item: item,
        initialDate: initialDate,
      );
    },
  );
}
