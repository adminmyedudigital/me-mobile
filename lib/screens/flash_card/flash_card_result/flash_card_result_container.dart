import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:me_mobile/theme/theme.dart';
import 'package:me_mobile/controllers/controllers.dart';

part 'flash_card_result_card.dart';
part 'flash_card_result_header.dart';
part 'flash_card_score_ring.dart';
part 'flash_card_result_metrics.dart';
part 'flash_card_result_metric_card.dart';
part 'flash_card_result_summary.dart';

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

      return _FlashCardResultCard(
        correctCount: correctCount,
        wrongCount: wrongCount,
        skipCount: skipCount,
        cardCount: cardCount,
        progressPercent: progressPercent,
      );
    });
  }
}
