import 'package:flutter/material.dart';
import 'package:me_mobile/screens/screens.dart';

final class AppRoutes {
  const AppRoutes._();

  static const String quiz = '/quiz';
  static const String home = '/home';
  static const String study = '/study';
  static const String signIn = '/signin';
  static const String signUp = '/signup';
  static const String profile = '/profile';
  static const String flashCard = '/flash-card';
  static const String examResult = '/exam-result';
  static const String dayTimetable = '/day-timetable';
  static const String academicSetup = '/academic-setup';
  static const String changeUsername = '/change-username';
  static const String changePassword = '/change-password';
  static const String scheduleTimetable = '/schedule-timetable';
  static const String topicUnderstanding = '/topic-understanding';

  static Map<String, WidgetBuilder> get routes {
    return {
      study: (_) => const StudyScreen(),
      quiz: (_) => const QuizContainer(),
      profile: (_) => const ProfileScreen(),
      home: (_) => const HomeScreenContainer(),
      dayTimetable: (_) => const DayTimetable(),
      examResult: (_) => const ExamResultScreen(),
      signUp: (_) => const SignUpScreenContainer(),
      signIn: (_) => const SignInScreenContainer(),
      flashCard: (_) => const FlashCardContainer(),
      academicSetup: (_) => const AcademicSetupScreen(),
      changeUsername: (_) => const ChangeUsernameScreen(),
      changePassword: (_) => const ChangePasswordScreen(),
      scheduleTimetable: (_) => const ScheduleTimetable(),
      topicUnderstanding: (_) => const TopicUnderstandingScreen(),
    };
  }
}
