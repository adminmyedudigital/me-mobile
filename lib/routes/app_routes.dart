import 'package:flutter/material.dart';
import 'package:me_mobile/screens/screens.dart';

final class AppRoutes {
  const AppRoutes._();

  static const String quiz = '/quiz';
  static const String home = '/home';
  static const String signIn = '/signin';
  static const String signUp = '/signup';
  static const String flashCard = '/flash-card';
  static const String dayTimetable = '/day-timetable';
  static const String scheduleTimetable = '/schedule-timetable';

  static Map<String, WidgetBuilder> get routes {
    return {
      quiz: (_) => const QuizContainer(),
      home: (_) => const HomeScreenContainer(),
      dayTimetable: (_) => const DayTimetable(),
      signIn: (_) => const SignInScreenContainer(),
      signUp: (_) => const SignUpScreenContainer(),
      flashCard: (_) => const FlashCardContainer(),
      scheduleTimetable: (_) => const ScheduleTimetable(),
    };
  }
}
