import 'package:flutter/material.dart';

import 'package:me_mobile/theme/theme.dart';
import 'package:me_mobile/screens/screens.dart';
import 'package:me_mobile/widgets/widgets.dart';

class AuthTabsScreen extends StatefulWidget {
  const AuthTabsScreen({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<AuthTabsScreen> createState() => _AuthTabsScreenState();
}

class _AuthTabsScreenState extends State<AuthTabsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialIndex.clamp(0, 1),
    );
    _tabController.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _tabController.index;
    final colors = context.colors;

    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomRight,
            colors: [
              colors.accentOrangeGlow.withValues(alpha: 0.52),
              colors.canvas.withValues(alpha: 0.94),
              colors.canvas,
            ],
            stops: const [0, 0.30, 0],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.centerRight,
                    child: ThemeToggleButton(),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AuthLogo(currentIndex: currentIndex),
                  const SizedBox(height: 30),
                  AuthTabSelector(
                    currentIndex: currentIndex,
                    onChanged: (index) => _tabController.animateTo(index),
                  ),
                  const SizedBox(height: 30),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    switchInCurve: Curves.easeOut,
                    switchOutCurve: Curves.easeIn,
                    child: currentIndex == 0
                        ? const SignInForm(key: ValueKey('sign-in-form'))
                        : const SignUpWeb(key: ValueKey('sign-up-web')),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
