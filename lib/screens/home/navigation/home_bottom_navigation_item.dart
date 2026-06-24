import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:me_mobile/screens/home/navigation/home_navigation_destination.dart';
import 'package:me_mobile/theme/theme.dart';

class HomeBottomNavigationItem extends StatelessWidget {
  const HomeBottomNavigationItem({
    super.key,
    required this.destination,
    required this.selected,
    required this.onTap,
  });

  final HomeNavigationDestination destination;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(AppRadius.full);

    return Tooltip(
      message: destination.title,
      child: Semantics(
        label: destination.title,
        selected: selected,
        button: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          child: ClipRRect(
            borderRadius: borderRadius,
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: selected ? 22 : 12,
                sigmaY: selected ? 22 : 12,
              ),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                height: AppSpacing.xxxl,
                decoration: BoxDecoration(
                  color: selected
                      ? context.colors.surfaceElevated.withAlpha(36)
                      : context.colors.surfaceCard.withAlpha(10),
                  borderRadius: borderRadius,
                  border: selected
                      ? null
                      : Border.all(color: context.colors.hairline),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      selected
                          ? context.colors.ink.withAlpha(12)
                          : context.colors.ink.withAlpha(5),
                      selected
                          ? context.colors.surfaceElevated.withAlpha(38)
                          : context.colors.surfaceCard.withAlpha(14),
                      selected
                          ? context.colors.accentOrangeGlow.withAlpha(86)
                          : context.colors.surfaceDeep.withAlpha(20),
                    ],
                  ),
                  boxShadow: selected
                      ? [
                          BoxShadow(
                            color: context.colors.accentOrangeGlow.withAlpha(
                              96,
                            ),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ]
                      : null,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: borderRadius,
                    onTap: onTap,
                    splashColor: context.colors.accentOrangeGlow,
                    highlightColor: context.colors.ink.withAlpha(8),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 180),
                          opacity: selected ? 1 : 0,
                          child: Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  context.colors.accentOrangeGlow.withAlpha(
                                    150,
                                  ),
                                  context.colors.accentOrangeGlow.withAlpha(0),
                                ],
                              ),
                            ),
                          ),
                        ),
                        AnimatedScale(
                          duration: const Duration(milliseconds: 180),
                          scale: selected ? 1.08 : 1,
                          curve: Curves.easeOutCubic,
                          child: Icon(
                            selected
                                ? destination.activeIcon
                                : destination.icon,
                            color: selected
                                ? context.colors.accentOrange
                                : context.colors.charcoal,
                            size: selected ? 25 : 23,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
