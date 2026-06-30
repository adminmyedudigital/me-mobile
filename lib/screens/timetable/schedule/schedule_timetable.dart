import 'package:flutter/material.dart';

import 'package:me_mobile/theme/theme.dart';

class ScheduleTimetable extends StatelessWidget {
  const ScheduleTimetable({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      appBar: AppBar(title: const Text('Schedule time table')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Form(
              child: Container(
                constraints: const BoxConstraints(minHeight: 360),
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: AppRadius.card,
                  border: Border.all(
                    color: colors.hairlineStrong.withValues(alpha: 0.72),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colors.canvas.withValues(alpha: 0.36),
                      blurRadius: 24,
                      offset: const Offset(0, 14),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
