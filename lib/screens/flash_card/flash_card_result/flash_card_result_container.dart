import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:me_mobile/screens/screens.dart';
import 'package:me_mobile/controllers/controllers.dart';

class FlashCardResult extends StatelessWidget {
  const FlashCardResult({super.key});

  @override
  Widget build(BuildContext context) {
    final flashCardController = Get.find<FlashCardController>();

    return Obx(() {
      final cardCount = flashCardController.cards.length;
      final correctCount = flashCardController.correctCount;
      final wrongCount = flashCardController.wrongCount;
      final skipCount = flashCardController.skipCount;
      final progressPercent = flashCardController.progressPercent;

      return FlashCardResultCard(
        correctCount: correctCount,
        wrongCount: wrongCount,
        skipCount: skipCount,
        cardCount: cardCount,
        progressPercent: progressPercent,
      );
    });
  }
}
