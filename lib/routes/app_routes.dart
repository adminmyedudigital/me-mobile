import 'package:flutter/material.dart';
import 'package:me_mobile/screens/screens.dart';

final class AppRoutes {
  const AppRoutes._();

  static const String quiz = '/quiz';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String changeUsername = '/change-username';
  static const String changePassword = '/change-password';
  static const String signIn = '/signin';
  static const String signUp = '/signup';
  static const String flashCard = '/flash-card';
  static const String examResult = '/exam-result';
  static const String dayTimetable = '/day-timetable';
  static const String scheduleTimetable = '/schedule-timetable';

  static Map<String, WidgetBuilder> get routes {
    return {
      quiz: (_) => const QuizContainer(),
      home: (_) => const HomeScreenContainer(),
      profile: (_) => const ProfileScreen(),
      changeUsername: (_) => const ChangeUsernameScreen(),
      changePassword: (_) => const ChangePasswordScreen(),
      dayTimetable: (_) => const DayTimetable(),
      examResult: (_) => const ExamResultScreen(),
      flashCard: (_) => const FlashCardContainer(),
      signUp: (_) => const SignUpScreenContainer(),
      signIn: (_) => const SignInScreenContainer(),
      scheduleTimetable: (_) => const ScheduleTimetable(),
    };
  }
}
