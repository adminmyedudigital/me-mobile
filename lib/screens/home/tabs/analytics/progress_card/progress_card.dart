import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:me_mobile/controllers/controllers.dart';
import 'package:me_mobile/screens/home/tabs/analytics/progress_card/progress_card_header.dart';
import 'package:me_mobile/screens/home/tabs/analytics/progress_card/progress_chart.dart';
import 'package:me_mobile/screens/home/tabs/analytics/progress_card/progress_metric.dart';
import 'package:me_mobile/theme/theme.dart';

class ProgressCard extends StatefulWidget {
  const ProgressCard({super.key});

  @override
  State<ProgressCard> createState() => _ProgressCardState();
}

class _ProgressCardState extends State<ProgressCard> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void didUpdateWidget(covariant ProgressCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    final controller = Get.find<AnalyticsController>();
    controller.changeSlide(controller.currentSlide.value);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AnalyticsController>();

    return Obx(
      () => Container(
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
              currentTitle: controller.currentProgress.title,
              slideCount: controller.progressItems.length,
              currentSlide: controller.currentSlide.value,
            ),
            SizedBox(
              height: 230,
              child: PageView.builder(
                controller: _pageController,
                itemCount: controller.progressItems.length,
                onPageChanged: controller.changeSlide,
                itemBuilder: (context, index) {
                  final progressItem = controller.progressItems[index];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: AppSpacing.md),
                      ProgressChart(progressItem: progressItem),
                      const SizedBox(height: AppSpacing.md),
                      ProgressMetricGrid(
                        metrics: [
                          ProgressMetricData(
                            title: 'Weekly Study',
                            value: '${progressItem.currentWeekStudyProgress}%',
                            icon: Icons.edit_note,
                            color: context.colors.accentGreen,
                          ),
                          ProgressMetricData(
                            title: 'Weekly Exam',
                            value: '${progressItem.currentWeekExamProgress}%',
                            icon: Icons.assignment_turned_in_outlined,
                            color: context.colors.accentBlue,
                          ),
                          ProgressMetricData(
                            title: 'Monthly Study',
                            value: '${progressItem.currentMonthStudyProgress}%',
                            icon: Icons.calendar_month_outlined,
                            color: context.colors.accentBlue,
                          ),
                          ProgressMetricData(
                            title: 'Monthly Exam',
                            value: '${progressItem.currentMonthExamProgress}%',
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
      ),
    );
  }
}
