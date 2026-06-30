import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:me_mobile/enums/enums.dart';
import 'package:me_mobile/theme/theme.dart';
import 'package:me_mobile/screens/screens.dart';
import 'package:me_mobile/controllers/controllers.dart';

class FlashCardContainer extends StatefulWidget {
  const FlashCardContainer({super.key});

  @override
  State<FlashCardContainer> createState() => _FlashCardContainerState();
}

class _FlashCardContainerState extends State<FlashCardContainer>
    with SingleTickerProviderStateMixin {
  final FlashCardController _flashCardController =
      Get.find<FlashCardController>();
  late final AnimationController _controller;
  late final Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();
    _flashCardController.loadFromArgument(Get.arguments);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
      reverseDuration: const Duration(milliseconds: 420),
    );
    _flipAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubicEmphasized,
      reverseCurve: Curves.easeInOutCubic,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleBack() {
    Get.back();
  }

  Future<void> _flipCard() async {
    if (_controller.isAnimating) return;

    if (_flashCardController.showAnswer.value) {
      await _controller.reverse();
    } else {
      await _controller.forward();
    }

    _flashCardController.toggleAnswer();
  }

  void _goToCard(int direction) {
    if (_controller.isAnimating) return;

    if (direction > 0 && _flashCardController.isLastCard) {
      _flashCardController.submitResult();
      return;
    }

    if (_flashCardController.goToCard(direction)) {
      _controller.value = 0;
    }
  }

  void _setFeedback(FlashCardFeedback feedback) {
    if (_flashCardController.isLastCard) {
      _flashCardController.setFeedbackAndSubmit(feedback);
      return;
    }

    final didMoveToNextCard = _flashCardController.setFeedback(feedback);
    if (didMoveToNextCard) {
      _controller.value = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final showResult = _flashCardController.showResult.value;

      if (showResult) {
        return PopScope(
          canPop: true,
          child: Scaffold(
            appBar: AppBar(
              leading: BackButton(onPressed: _handleBack),
              title: Text(
                _flashCardController.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            body: const SafeArea(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: SingleChildScrollView(child: FlashCardResult()),
              ),
            ),
          ),
        );
      }

      final card = _flashCardController.currentCard;
      final currentIndex = _flashCardController.currentIndex.value;
      final cardCount = _flashCardController.cards.length;

      return PopScope(
        canPop: true,
        child: Scaffold(
          appBar: AppBar(
            leading: BackButton(onPressed: _handleBack),
            title: Text(
              _flashCardController.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AnimatedBuilder(
                    key: ValueKey(currentIndex),
                    animation: _flipAnimation,
                    builder: (context, _) {
                      final angle = _flipAnimation.value * math.pi;
                      final isAnswerSide = angle > math.pi / 2;
                      final displayAngle = isAnswerSide
                          ? angle + math.pi
                          : angle;

                      return Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.0012)
                          ..rotateY(displayAngle),
                        child: isAnswerSide
                            ? FlashCardFace(
                                label: 'Answer',
                                icon: Icons.menu_book,
                                title: card.answer,
                                body: card.explanation,
                                actionText: 'Question',
                                alertText: 'Explanation',
                                currentIndex: currentIndex,
                                cardCount: cardCount,
                                onPressed: _flipCard,
                              )
                            : FlashCardFace(
                                label: 'Question',
                                icon: Icons.lightbulb_outline_rounded,
                                title: card.question,
                                body: card.hint,
                                actionText: 'See answer',
                                alertText: 'Hint',
                                currentIndex: currentIndex,
                                cardCount: cardCount,
                                onPressed: _flipCard,
                              ),
                      );
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  FlashCardControls(
                    currentIndex: currentIndex,
                    cardCount: cardCount,
                    canGoPrevious: _flashCardController.canGoPrevious,
                    canGoNext:
                        _flashCardController.canGoNext ||
                        _flashCardController.isLastCard,
                    selectedFeedback: _flashCardController.selectedFeedback,
                    onPrevious: () => _goToCard(-1),
                    onNext: () => _goToCard(1),
                    onFeedbackSelected: _setFeedback,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
