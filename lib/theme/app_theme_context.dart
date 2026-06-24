import 'package:flutter/material.dart';

import 'app_colors.dart';

extension AppThemeContext on BuildContext {
  ThemeData get theme => Theme.of(this);

  AppColors get colors => theme.extension<AppColors>()!;

  TextTheme get textTheme => theme.textTheme;

  ColorScheme get colorScheme => theme.colorScheme;
}
