import 'package:get/get.dart';
import 'package:me_mobile/screens/home/tabs/analytics/progress_card/study_progress_summary.dart';

class AnalyticsController extends GetxController {
  final RxInt currentSlide = 0.obs;

  final List<StudyProgressSummary> progressItems = const [
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

  StudyProgressSummary get currentProgress {
    if (progressItems.isEmpty) {
      return const StudyProgressSummary(
        studyProgress: 0,
        examProgress: 0,
        title: 'Progress',
        currentWeekStudyProgress: 0,
        currentWeekExamProgress: 0,
        currentMonthStudyProgress: 0,
        currentMonthExamProgress: 0,
      );
    }

    return progressItems[currentSlide.value.clamp(0, progressItems.length - 1)];
  }

  void changeSlide(int index) {
    if (progressItems.isEmpty) {
      currentSlide.value = 0;
      return;
    }

    currentSlide.value = index.clamp(0, progressItems.length - 1);
  }
}
