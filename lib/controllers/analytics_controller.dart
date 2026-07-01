import 'package:get/get.dart';
import 'package:me_mobile/screens/home/tabs/analytics/progress_card/study_progress_summary.dart';

class AnalyticsController extends GetxController {
  final RxInt currentSlide = 0.obs;

  final RxList<StudyProgressSummary> progressItems = <StudyProgressSummary>[
    StudyProgressSummary(
      title: 'Progress',
      subTitle: 'Over all progress',
      totalProgress: 60,
      studyProgress: 40,
      examProgress: 20,
      weeklyStudyProgress: 90,
      weeklyExamProgress: 10,
      monthlyStudyProgress: 50,
      monthlyExamProgress: 10,
      barChartTitle: 'Subject Progress',
      barChartData: [
        ProgressBarChartData(label: 'maths', data: 20),
        ProgressBarChartData(label: 'science', data: 30),
        ProgressBarChartData(label: 'maths', data: 20),
        ProgressBarChartData(label: 'science', data: 30),
        ProgressBarChartData(label: 'maths', data: 20),
        ProgressBarChartData(label: 'science', data: 30),
        ProgressBarChartData(label: 'maths', data: 20),
        ProgressBarChartData(label: 'science', data: 30),
      ],
    ),
    StudyProgressSummary(
      title: 'Science',
      subTitle: 'Science subject progress',
      totalProgress: 30,
      studyProgress: 40,
      examProgress: 20,
      weeklyStudyProgress: 90,
      weeklyExamProgress: 10,
      monthlyStudyProgress: 50,
      monthlyExamProgress: 10,
      barChartTitle: 'Topics progress',
      barChartData: [
        ProgressBarChartData(label: 'Topic1', data: 20),
        ProgressBarChartData(label: 'Topic2', data: 30),
      ],
    ),
  ].obs;

  StudyProgressSummary get currentProgress {
    if (progressItems.isEmpty) {
      return const StudyProgressSummary(
        title: 'Progress',
        subTitle: 'Over all progress',
        totalProgress: 0,
        studyProgress: 0,
        examProgress: 0,
        weeklyStudyProgress: 0,
        weeklyExamProgress: 0,
        monthlyStudyProgress: 0,
        monthlyExamProgress: 0,
        barChartTitle: 'Progress breakdown',
        barChartData: [],
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

  void setProgressItemsFromApi(List<dynamic> response) {
    final items = [
      for (final item in response)
        if (item is Map<String, dynamic>) StudyProgressSummary.fromJson(item),
    ];

    progressItems.assignAll(items);
    changeSlide(currentSlide.value);
  }
}
