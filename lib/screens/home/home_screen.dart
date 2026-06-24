import 'package:flutter/material.dart';
import 'package:me_mobile/screens/screens.dart';
import 'package:me_mobile/routes/app_routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  static const _tabs = [
    HomeNavigationDestination(
      title: 'Dashboard',
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      child: DashboardTab(),
    ),
    HomeNavigationDestination(
      title: 'Exam',
      icon: Icons.assignment_outlined,
      activeIcon: Icons.assignment,
      child: ExamTab(),
    ),
    HomeNavigationDestination(
      title: 'Chart',
      icon: Icons.insert_chart_outlined,
      activeIcon: Icons.insert_chart,
      child: ChartTab(),
    ),
    HomeNavigationDestination(
      title: 'Settings',
      icon: Icons.settings_outlined,
      activeIcon: Icons.settings,
      child: SettingsTab(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: Text(_tabs[_currentIndex].title),
        actions: [
          IconButton(
            tooltip: 'Sign out',
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(AppRoutes.signIn);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: IndexedStack(
          index: _currentIndex,
          children: [for (final tab in _tabs) tab.child],
        ),
      ),
      bottomNavigationBar: HomeBottomNavigation(
        currentIndex: _currentIndex,
        destinations: _tabs,
        onChanged: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
