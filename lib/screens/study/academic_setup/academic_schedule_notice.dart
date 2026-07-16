import 'package:flutter/material.dart';

import 'package:me_mobile/theme/theme.dart';
import 'package:me_mobile/screens/study/academic_setup/academic_schedule_notice_point.dart';

class AcademicScheduleNotice extends StatelessWidget {
  const AcademicScheduleNotice({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colors.accentOrange.withValues(alpha: 0.08),
        borderRadius: AppRadius.card,
        border: Border.all(color: colors.accentOrange.withValues(alpha: 0.24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: colors.accentOrange.withValues(alpha: 0.16),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.info_outline_rounded,
                  color: colors.accentOrange,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Before you save',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: colors.ink,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      'Please keep these points in mind',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colors.charcoal,
                        letterSpacing: 0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            child: Divider(
              height: 1,
              color: colors.accentOrange.withValues(alpha: 0.2),
            ),
          ),
          const AcademicScheduleNoticePoint(
            icon: Icons.lock_outline_rounded,
            message:
                "After you save this schedule, you can't change it until the academic year ends.",
          ),
          const SizedBox(height: AppSpacing.md),
          const AcademicScheduleNoticePoint(
            icon: Icons.support_agent_rounded,
            message: 'Need to make a change? Contact the Help Desk team.',
          ),
        ],
      ),
    );
  }
}
