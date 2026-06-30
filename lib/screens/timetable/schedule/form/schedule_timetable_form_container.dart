import 'package:flutter/material.dart';

import 'package:me_mobile/controllers/controllers.dart';
import 'package:me_mobile/screens/timetable/schedule/form/schedule_timetable_form.dart';
import 'package:me_mobile/theme/theme.dart';

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
      final bottomInset = MediaQuery.viewInsetsOf(sheetContext).bottom;

      return Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.md,
          0,
          AppSpacing.md,
          bottomInset + AppSpacing.lg,
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
