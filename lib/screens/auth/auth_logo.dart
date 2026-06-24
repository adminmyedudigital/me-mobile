import 'package:flutter/material.dart';

class AuthLogo extends StatelessWidget {
  const AuthLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Image.asset(
        'assets/images/logo.png',
        width: 70,
        height: 70,
        fit: BoxFit.contain,
        semanticLabel: 'ME Digital logo',
      ),
    );
  }
}
