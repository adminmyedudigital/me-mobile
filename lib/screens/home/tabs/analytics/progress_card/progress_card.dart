import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:me_mobile/controllers/controllers.dart';
import 'package:me_mobile/screens/home/tabs/analytics/progress_card/progress_bar_chart.dart';
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
    final colors = context.colors;
    final isLightTheme = Theme.of(context).brightness == Brightness.light;

    return Obx(
      () => Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: colors.surfaceDeep,
          borderRadius: AppRadius.button,
          border: Border.all(
            color: isLightTheme ? colors.hairline : colors.hairlineStrong,
          ),
          boxShadow: [
            if (isLightTheme)
              BoxShadow(
                color: colors.primary.withValues(alpha: 0.06),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: ProgressCardHeader(
                title: controller.currentProgress.displayTitle,
                currentTitle: controller.currentProgress.displaySubTitle,
                slideCount: controller.progressItems.length,
                currentSlide: controller.currentSlide.value,
              ),
            ),
            SizedBox(
              height: _contentHeight,
              child: PageView.builder(
                controller: _pageController,
                itemCount: controller.progressItems.length,
                onPageChanged: controller.changeSlide,
                itemBuilder: (context, index) {
                  final progressItem = controller.progressItems[index];

                  return Scrollbar(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        const reservedContentHeight = 236.0;
                        final chartHeight =
                            (constraints.maxHeight - reservedContentHeight)
                                .clamp(220.0, 260.0);

                        return SingleChildScrollView(
                          padding: const EdgeInsets.only(right: AppSpacing.xs),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ProgressChart(progressItem: progressItem),
                              const SizedBox(height: AppSpacing.md),
                              ProgressMetricGrid(
                                metrics: [
                                  ProgressMetricData(
                                    title: 'Weekly Study',
                                    value:
                                        '${progressItem.weeklyStudyProgress}%',
                                    icon: Icons.edit_note,
                                    color: colors.primary,
                                  ),
                                  ProgressMetricData(
                                    title: 'Weekly Exam',
                                    value:
                                        '${progressItem.weeklyExamProgress}%',
                                    icon: Icons.assignment_turned_in_outlined,
                                    color: colors.primary,
                                  ),
                                  ProgressMetricData(
                                    title: 'Monthly Study',
                                    value:
                                        '${progressItem.monthlyStudyProgress}%',
                                    icon: Icons.calendar_month_outlined,
                                    color: colors.primary,
                                  ),
                                  ProgressMetricData(
                                    title: 'Monthly Exam',
                                    value:
                                        '${progressItem.monthlyExamProgress}%',
                                    icon: Icons.fact_check_outlined,
                                    color: colors.primary,
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.md),
                              SizedBox(
                                height: chartHeight,
                                child: ProgressBarChart(
                                  title: progressItem.displayBarChartTitle,
                                  items: progressItem.barChartData,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  static const double _contentHeight = 472;
}
