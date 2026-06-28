import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:me_mobile/theme/theme.dart';
import 'package:me_mobile/screens/screens.dart';
import 'package:me_mobile/controllers/dashboard_controller.dart';

class DayTimetable extends StatefulWidget {
  const DayTimetable({super.key});

  @override
  State<DayTimetable> createState() => _DayTimetableState();
}

class _DayTimetableState extends State<DayTimetable> {
  int? _expandedEventIndex;

  String _dateTitle(DateTime date) {
    final month = DashboardDateUtils.monthNames[date.month - 1];
    return '${DashboardDateUtils.weekdayName(date)}, ${date.day} $month';
  }

  void _handleBack(DashboardController controller) {
    controller.clearTimetableSlot();
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (_, _) {
        controller.clearTimetableSlot();
      },
      child: Obx(() {
        final selectedDate =
            controller.selectedTimetableDate.value ??
            controller.selectedDate.value;
        final events = controller.selectedTimetableEvents;

        return Scaffold(
          appBar: AppBar(
            leading: BackButton(onPressed: () => _handleBack(controller)),
            title: Text(_dateTitle(selectedDate)),
          ),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.band,
              ),
              children: [
                if (events.isEmpty)
                  const EmptyTimetable()
                else ...[
                  for (final entry in events.indexed) ...[
                    DayTimeTableBadge(
                      event: entry.$2,
                      isExpanded: _expandedEventIndex == entry.$1,
                      onTap: () {
                        setState(() {
                          _expandedEventIndex = _expandedEventIndex == entry.$1
                              ? null
                              : entry.$1;
                        });
                      },
                    ),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 260),
                      reverseDuration: const Duration(milliseconds: 180),
                      switchInCurve: Curves.easeOutCubic,
                      switchOutCurve: Curves.easeInCubic,
                      layoutBuilder: (currentChild, previousChildren) {
                        return Stack(
                          alignment: Alignment.topCenter,
                          children: [...previousChildren, ?currentChild],
                        );
                      },
                      transitionBuilder: (child, animation) {
                        final curvedAnimation = CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeOutCubic,
                          reverseCurve: Curves.easeInCubic,
                        );

                        return FadeTransition(
                          opacity: curvedAnimation,
                          child: SizeTransition(
                            sizeFactor: curvedAnimation,
                            fixedCrossAxisSizeFactor: 1,
                            alignment: Alignment.topCenter,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0, -0.04),
                                end: Offset.zero,
                              ).animate(curvedAnimation),
                              child: ScaleTransition(
                                scale: Tween<double>(
                                  begin: 0.98,
                                  end: 1,
                                ).animate(curvedAnimation),
                                child: child,
                              ),
                            ),
                          ),
                        );
                      },
                      child: _expandedEventIndex == entry.$1
                          ? Padding(
                              key: ValueKey('panel-${entry.$1}'),
                              padding: const EdgeInsets.only(
                                top: AppSpacing.sm,
                              ),
                              child: DayTimetablePlan(event: entry.$2),
                            )
                          : const SizedBox.shrink(),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                  ],
                  const SizedBox(height: AppSpacing.lg),
                ],
              ],
            ),
          ),
        );
      }),
    );
  }
}
