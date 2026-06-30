import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:me_mobile/enums/enums.dart';
import 'package:me_mobile/theme/theme.dart';
import 'package:me_mobile/screens/screens.dart';
import 'package:me_mobile/widgets/widgets.dart';
import 'package:me_mobile/routes/app_routes.dart';
import 'package:me_mobile/controllers/controllers.dart';

class HomeScreenContainer extends StatelessWidget {
  const HomeScreenContainer({super.key});

  static const _dashboardTabIndex = 0;

  static const _tabs = [
    HomeNavigationDestination(
      title: 'Dashboard',
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      child: DashboardTabContainer(),
    ),
    HomeNavigationDestination(
      title: 'Exam',
      icon: Icons.assignment_outlined,
      activeIcon: Icons.assignment,
      child: ExamsTabContainer(),
    ),
    HomeNavigationDestination(
      title: 'Analytics',
      icon: Icons.insert_chart_outlined,
      activeIcon: Icons.insert_chart,
      child: AnalyticsTabContainer(),
    ),
    HomeNavigationDestination(
      title: 'Settings',
      icon: Icons.settings_outlined,
      activeIcon: Icons.settings,
      child: SettingsTabContainer(),
    ),
  ];

  Future<void> _createUpcomingTimetable(
    BuildContext context,
    DashboardController controller,
  ) async {
    final now = DashboardDateUtils.dateOnly(DateTime.now());
    final initialDate = controller.selectedDate.value.isAfter(now)
        ? controller.selectedDate.value
        : now.add(const Duration(days: 7));

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: now.add(const Duration(days: 1)),
      lastDate: now.add(const Duration(days: 84)),
      helpText: 'Create timetable',
      confirmText: 'Create',
      cancelText: 'Cancel',
    );

    if (pickedDate == null) return;

    controller
      ..selectDate(pickedDate)
      ..changeView(CalendarView.week)
      ..selectTimetableSlot(
        date: pickedDate,
        hour: 9,
        events: controller.eventsForDate(pickedDate),
      );

    Get.toNamed(AppRoutes.dayTimetable);
  }

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();
    final appController = Get.find<AppController>();
    final dashboardController = Get.find<DashboardController>();

    return Obx(() {
      final currentIndex = homeController.currentIndex.value;
      final isDashboardTab = currentIndex == _dashboardTabIndex;
      final colors = context.colors;

      return Scaffold(
        extendBody: true,
        appBar: AppBar(
          title: Text(_tabs[currentIndex].title),
          actions: [
            const ThemeToggleButton(),
            IconButton(
              tooltip: 'Sign out',
              onPressed: appController.signOut,
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        body: SafeArea(
          bottom: false,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: isDashboardTab ? AppSpacing.xxxl : 0,
            ),
            child: IndexedStack(
              index: currentIndex,
              children: [for (final tab in _tabs) tab.child],
            ),
          ),
        ),
        bottomNavigationBar: HomeBottomNavigation(
          currentIndex: currentIndex,
          destinations: _tabs,
          onChanged: homeController.changeTab,
        ),
        floatingActionButton: isDashboardTab
            ? Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: colors.primary.withValues(alpha: 0.28),
                      blurRadius: 24,
                      offset: const Offset(0, 12),
                    ),
                    BoxShadow(
                      color: colors.canvas.withValues(alpha: 0.32),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: FloatingActionButton(
                  tooltip: 'Create upcoming timetable',
                  elevation: 0,
                  focusElevation: 0,
                  hoverElevation: 0,
                  highlightElevation: 0,
                  backgroundColor: colors.primary,
                  foregroundColor: colors.primaryOn,
                  shape: CircleBorder(
                    side: BorderSide(
                      color: colors.primaryOn.withValues(alpha: 0.12),
                    ),
                  ),
                  onPressed: () {
                    _createUpcomingTimetable(context, dashboardController);
                  },
                  child: const Icon(Icons.add_rounded, size: 30),
                ),
              )
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      );
    });
  }
}
