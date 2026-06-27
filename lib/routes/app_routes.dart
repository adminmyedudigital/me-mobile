import 'package:flutter/material.dart';
import 'package:me_mobile/screens/screens.dart';

final class AppRoutes {
  const AppRoutes._();

  static const String signIn = '/signin';
  static const String signUp = '/signup';
  static const String home = '/home';

  static Map<String, WidgetBuilder> get routes {
    return {
      signIn: (_) => const SignInScreenContainer(),
      signUp: (_) => const SignUpScreenContainer(),
      home: (_) => const HomeScreenContainer(),
    };
  }
}
