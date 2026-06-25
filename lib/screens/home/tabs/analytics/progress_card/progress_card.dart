import 'package:flutter/material.dart';
import 'package:me_mobile/screens/home/tabs/analytics/progress_card/progress_card_header.dart';
import 'package:me_mobile/screens/home/tabs/analytics/progress_card/progress_chart.dart';
import 'package:me_mobile/screens/home/tabs/analytics/progress_card/progress_metric.dart';
import 'package:me_mobile/screens/home/tabs/analytics/progress_card/study_progress_summary.dart';
import 'package:me_mobile/theme/theme.dart';

class ProgressCard extends StatefulWidget {
  const ProgressCard({super.key});

  @override
  State<ProgressCard> createState() => _ProgressCardState();
}

class _ProgressCardState extends State<ProgressCard> {
  late final PageController _pageController;
  int currentSlide = 0;
  static const progressItems = [
    StudyProgressSummary(
      studyProgress: 72,
      examProgress: 48,
      title: 'Over all progress',
      currentWeekStudyProgress: 18,
      currentWeekExamProgress: 12,
      currentMonthStudyProgress: 64,
      currentMonthExamProgress: 38,
    ),
    StudyProgressSummary(
      studyProgress: 58,
      examProgress: 34,
      title: 'Science',
      currentWeekStudyProgress: 16,
      currentWeekExamProgress: 8,
      currentMonthStudyProgress: 52,
      currentMonthExamProgress: 28,
    ),
    StudyProgressSummary(
      studyProgress: 81,
      examProgress: 62,
      title: 'Mathematics',
      currentWeekStudyProgress: 22,
      currentWeekExamProgress: 14,
      currentMonthStudyProgress: 74,
      currentMonthExamProgress: 56,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void didUpdateWidget(covariant ProgressCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (currentSlide >= progressItems.length) {
      currentSlide = 0;
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: context.colors.accentGreenGlow,
        borderRadius: AppRadius.card,
        border: Border.all(color: context.colors.accentGreenGlow),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            context.colors.accentGreenGlow.withAlpha(18),
            context.colors.accentGreenGlow,
            context.colors.accentGreenGlow,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: context.colors.accentGreenGlow.withAlpha(10),
            blurRadius: 34,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProgressCardHeader(
            title: "Progress",
            currentTitle: progressItems[currentSlide].title,
            slideCount: progressItems.length,
            currentSlide: 0,
          ),
          SizedBox(
            height: 230,
            child: PageView.builder(
              controller: _pageController,
              itemCount: progressItems.length,
              onPageChanged: (index) {
                setState(() => currentSlide = index);
              },
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSpacing.md),
                    ProgressChart(progressItem: progressItems[index]),
                    const SizedBox(height: AppSpacing.md),
                    ProgressMetricGrid(
                      metrics: [
                        ProgressMetricData(
                          title: 'Weekly Study',
                          value:
                              '${progressItems[index].currentWeekStudyProgress}%',
                          icon: Icons.edit_note,
                          color: context.colors.accentGreen,
                        ),
                        ProgressMetricData(
                          title: 'Weekly Exam',
                          value:
                              '${progressItems[index].currentWeekExamProgress}%',
                          icon: Icons.assignment_turned_in_outlined,
                          color: context.colors.accentBlue,
                        ),
                        ProgressMetricData(
                          title: 'Monthly Study',
                          value:
                              '${progressItems[index].currentMonthStudyProgress}%',
                          icon: Icons.calendar_month_outlined,
                          color: context.colors.accentBlue,
                        ),
                        ProgressMetricData(
                          title: 'Monthly Exam',
                          value:
                              '${progressItems[index].currentMonthExamProgress}%',
                          icon: Icons.fact_check_outlined,
                          color: context.colors.accentGreen,
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
