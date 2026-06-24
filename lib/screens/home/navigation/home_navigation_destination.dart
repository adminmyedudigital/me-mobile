import 'package:flutter/material.dart';

class HomeNavigationDestination {
  const HomeNavigationDestination({
    required this.title,
    required this.icon,
    required this.activeIcon,
    required this.child,
  });

  final String title;
  final IconData icon;
  final IconData activeIcon;
  final Widget child;
}
