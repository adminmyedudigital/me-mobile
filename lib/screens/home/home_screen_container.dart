import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:me_mobile/enums/enums.dart';
import 'package:me_mobile/theme/theme.dart';
import 'package:me_mobile/screens/screens.dart';
import 'package:me_mobile/widgets/widgets.dart';
import 'package:me_mobile/routes/app_routes.dart';
import 'package:me_mobile/controllers/controllers.dart';
import 'package:me_mobile/screens/home/add_timetable_alert.dart';
import 'package:me_mobile/screens/home/feature_access_alert.dart';
import 'package:me_mobile/screens/home/home_floating_action_button.dart';

class HomeScreenContainer extends StatefulWidget {
  const HomeScreenContainer({super.key});

  @override
  State<HomeScreenContainer> createState() => _HomeScreenContainerState();
}

class _HomeScreenContainerState extends State<HomeScreenContainer> {
  bool _isRequirementDialogVisible = false;

  static const _dashboardTabIndex = 0;
  static const _examTabIndex = 1;
  static const _analyticsTabIndex = 2;

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

  Future<void> _confirmScheduleTimetable(
    BuildContext context,
    HomeController controller,
  ) async {
    final action = await showAddTimetableAlert(context);

    switch (action) {
      case AddTimetableAlertAction.schedule:
        Get.toNamed(AppRoutes.scheduleTimetable);
      case AddTimetableAlertAction.addMarks:
        await _openExamResult();
      case null:
        return;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _showRequirement(AppFeature.dashboard);
    });
  }

  AppFeature? _featureForTab(int index) {
    return switch (index) {
      _dashboardTabIndex => AppFeature.dashboard,
      _examTabIndex => AppFeature.exams,
      _analyticsTabIndex => AppFeature.analytics,
      _ => null,
    };
  }

  Future<void> _changeTab(HomeController controller, int index) async {
    controller.changeTab(index);
    final feature = _featureForTab(index);

    if (feature != null) {
      await _showRequirement(feature);
    }

    if (index == _examTabIndex &&
        Get.find<FeatureAccessController>().canAccess(AppFeature.exams)) {
      final examsController = Get.find<ExamsController>();
      if (examsController.exams.isEmpty) {
        await examsController.loadExams();
      }
    }
  }

  Future<void> _showRequirement(AppFeature feature) async {
    if (_isRequirementDialogVisible || !mounted) return;

    final requirement = Get.find<FeatureAccessController>().unmetRequirement(
      feature,
    );

    if (requirement == null) return;

    _isRequirementDialogVisible = true;
    try {
      await showFeatureAccessAlert(context, requirement);
    } finally {
      _isRequirementDialogVisible = false;
    }
  }

  Future<void> _openExamResult() async {
    final examsController = Get.find<ExamsController>();
    if (examsController.isApiOperationInProgress) return;

    await examsController.loadSubjectTopics();
    if (!mounted) return;
    Get.toNamed(AppRoutes.examResult);
  }

  Widget? _buildFloatingActionButton({
    required int currentIndex,
    required bool canCreateTimetable,
    required bool canAddExamResult,
    required bool isExamApiOperationInProgress,
    required HomeController homeController,
  }) {
    return switch (currentIndex) {
      _dashboardTabIndex => HomeFloatingActionButton(
        enabledTooltip: 'Create upcoming timetable',
        onPressed: canCreateTimetable
            ? () => _confirmScheduleTimetable(context, homeController)
            : null,
      ),
      _examTabIndex => HomeFloatingActionButton(
        enabledTooltip: 'Add exam result',
        disabledTooltip: isExamApiOperationInProgress
            ? 'Please wait for the exam operation to finish'
            : 'Complete academic setup first',
        onPressed: canAddExamResult && !isExamApiOperationInProgress
            ? _openExamResult
            : null,
      ),
      _ => null,
    };
  }

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();
    final authController = Get.find<AuthController>();
    final accessController = Get.find<FeatureAccessController>();
    final examsController = Get.find<ExamsController>();

    return Obx(() {
      final currentIndex = homeController.currentIndex.value;
      final isDashboardTab = currentIndex == _dashboardTabIndex;
      final isExamTab = currentIndex == _examTabIndex;
      final hasFloatingActionButton = isDashboardTab || isExamTab;
      final canCreateTimetable = accessController.canAccess(
        AppFeature.createTimetable,
      );
      final canAddExamResult = accessController.canAccess(
        AppFeature.addExamResult,
      );
      final isLoadingExamSubjects = examsController.isLoadingSubjects.value;
      final isExamApiOperationInProgress =
          examsController.isApiOperationInProgress;

      return Stack(
        children: [
          Scaffold(
            extendBody: true,
            appBar: AppBar(
              title: Text(_tabs[currentIndex].title),
              actions: [
                const ThemeToggleButton(),
                IconButton(
                  tooltip: 'Sign out',
                  onPressed: authController.logout,
                  icon: const Icon(Icons.logout),
                ),
              ],
            ),
            body: SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: hasFloatingActionButton ? AppSpacing.xxxl : 0,
                  left: AppSpacing.xs,
                  right: AppSpacing.xs,
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
              onChanged: (index) => _changeTab(homeController, index),
            ),
            floatingActionButton: _buildFloatingActionButton(
              currentIndex: currentIndex,
              canCreateTimetable: canCreateTimetable,
              canAddExamResult: canAddExamResult,
              isExamApiOperationInProgress: isExamApiOperationInProgress,
              homeController: homeController,
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          ),
          if (isLoadingExamSubjects)
            const Positioned.fill(child: ExamSubjectsLoadingOverlay()),
        ],
      );
    });
  }
}
