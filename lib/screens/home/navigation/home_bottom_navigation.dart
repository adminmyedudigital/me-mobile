import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:me_mobile/screens/home/navigation/home_bottom_navigation_item.dart';
import 'package:me_mobile/screens/home/navigation/home_navigation_destination.dart';
import 'package:me_mobile/theme/theme.dart';

class HomeBottomNavigation extends StatelessWidget {
  const HomeBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.destinations,
    required this.onChanged,
  });

  final int currentIndex;
  final List<HomeNavigationDestination> destinations;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.full),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: context.colors.surfaceCard.withAlpha(26),
              borderRadius: BorderRadius.circular(AppRadius.full),
              border: Border.all(color: context.colors.hairline),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  context.colors.ink.withAlpha(10),
                  context.colors.surfaceElevated.withAlpha(34),
                  context.colors.surfaceDeep.withAlpha(48),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: context.colors.accentOrangeGlow.withAlpha(42),
                  blurRadius: 36,
                  offset: const Offset(0, 18),
                ),
                BoxShadow(
                  color: context.colors.canvas.withAlpha(80),
                  blurRadius: 28,
                  offset: const Offset(0, 14),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                children: [
                  for (var index = 0; index < destinations.length; index++)
                    Expanded(
                      child: HomeBottomNavigationItem(
                        destination: destinations[index],
                        selected: index == currentIndex,
                        onTap: () => onChanged(index),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
