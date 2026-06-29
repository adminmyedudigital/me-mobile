import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:me_mobile/theme/theme.dart';
import 'package:me_mobile/screens/screens.dart';
import 'package:me_mobile/controllers/controllers.dart';

class QuizContainer extends StatefulWidget {
  const QuizContainer({super.key});

  @override
  State<QuizContainer> createState() => _QuizContainerState();
}

class _QuizContainerState extends State<QuizContainer> {
  final QuizController _quizController = Get.find<QuizController>();

  @override
  void initState() {
    super.initState();
    _quizController.loadFromArgument(Get.arguments);
  }

  void _handleBack() {
    Get.back();
  }

  void _showHintDialog() {
    final colors = context.colors;
    final isLightTheme = Theme.of(context).brightness == Brightness.light;
    final question = _quizController.currentQuestion;

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isLightTheme
              ? colors.surfaceCard
              : colors.surfaceElevated,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.card,
            side: BorderSide(
              color: colors.accentOrange.withValues(
                alpha: isLightTheme ? 0.16 : 0.24,
              ),
            ),
          ),
          title: Text(
            'Hint',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: colors.ink,
              fontWeight: FontWeight.w800,
            ),
          ),
          content: Text(
            question.hint,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: colors.body),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(foregroundColor: colors.accentOrange),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final question = _quizController.currentQuestion;
      final currentQuestionIndex = _quizController.currentQuestionIndex.value;
      final questionCount = _quizController.questions.length;
      final selectedOptionIndex = _quizController.selectedOptionIndex;
      final showCorrectAnswer = _quizController.showCorrectAnswer;
      final isCorrect = _quizController.isCurrentAnswerCorrect;
      final canGoPrevious = _quizController.canGoPrevious;
      final canGoNext = _quizController.canGoNext;

      return Scaffold(
        appBar: AppBar(
          leading: BackButton(onPressed: _handleBack),
          title: Text(
            _quizController.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              QuizCard(
                question: question,
                currentQuestionIndex: currentQuestionIndex,
                questionCount: questionCount,
                showHintDialog: _showHintDialog,
                selectedOptionIndex: selectedOptionIndex,
                answerStateForOption: _quizController.answerStateForOption,
                onOptionSelected: _quizController.selectOption,
              ),
              const SizedBox(height: AppSpacing.lg),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                child: showCorrectAnswer
                    ? QuizAnswerPanel(
                        key: ValueKey('answer-$currentQuestionIndex'),
                        answer: question.correctAnswer,
                        isCorrect: isCorrect,
                      )
                    : const SizedBox.shrink(key: ValueKey('empty-answer')),
              ),
              const SizedBox(height: AppSpacing.md),
              QuizNavigationButton(
                canGoPrevious: canGoPrevious,
                canGoNext: canGoNext,
                onPreviousPressed: () => _quizController.goToQuestion(-1),
                onNextPressed: () => _quizController.goToQuestion(1),
              ),
            ],
          ),
        ),
      );
    });
  }
}
