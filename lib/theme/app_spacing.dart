import 'package:flutter/widgets.dart';

final class AppSpacing {
  const AppSpacing._();

  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;
  static const double section = 96;
  static const double band = 128;

  static const EdgeInsets button = EdgeInsets.symmetric(
    horizontal: lg,
    vertical: sm,
  );
  static const EdgeInsets card = EdgeInsets.all(xxl);
  static const EdgeInsets codeWindow = EdgeInsets.all(xl);
  static const EdgeInsets input = EdgeInsets.symmetric(
    horizontal: 14,
    vertical: 10,
  );
}
