import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:me_mobile/screens/screens.dart';
import 'package:me_mobile/controllers/controllers.dart';

class QuizResultContainer extends StatelessWidget {
  const QuizResultContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final quizController = Get.find<QuizController>();

    return Obx(() {
      final questionCount = quizController.questions.length;
      final correctAnswerCount = quizController.correctAnswerCount;
      final wrongAnswerCount = quizController.wrongAnswerCount;
      final progressPercent = quizController.progressPercent;

      return QuizResultCard(
        correctAnswerCount: correctAnswerCount,
        wrongAnswerCount: wrongAnswerCount,
        questionCount: questionCount,
        progressPercent: progressPercent,
      );
    });
  }
}
