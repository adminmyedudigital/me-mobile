import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:me_mobile/screens/screens.dart';
import 'package:me_mobile/widgets/widgets.dart';
import 'package:me_mobile/controllers/controllers.dart';

class HomeScreenContainer extends StatelessWidget {
  const HomeScreenContainer({super.key});

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

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();
    final appController = Get.find<AppController>();

    return Obx(() {
      final currentIndex = homeController.currentIndex.value;

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
          child: IndexedStack(
            index: currentIndex,
            children: [for (final tab in _tabs) tab.child],
          ),
        ),
        bottomNavigationBar: HomeBottomNavigation(
          currentIndex: currentIndex,
          destinations: _tabs,
          onChanged: homeController.changeTab,
        ),
      );
    });
  }
}
