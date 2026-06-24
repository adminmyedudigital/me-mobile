import 'package:flutter/material.dart';
import 'package:me_mobile/screens/screens.dart';

class AuthTabSelector extends StatelessWidget {
  const AuthTabSelector({
    super.key,
    required this.currentIndex,
    required this.onChanged,
  });

  final int currentIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AuthTabButton(
          key: const ValueKey('auth-tab-sign-in'),
          label: 'Sign In',
          selected: currentIndex == 0,
          onTap: () => onChanged(0),
        ),
        const SizedBox(width: 30),
        AuthTabButton(
          key: const ValueKey('auth-tab-sign-up'),
          label: 'Sign Up',
          selected: currentIndex == 1,
          onTap: () => onChanged(1),
        ),
      ],
    );
  }
}
