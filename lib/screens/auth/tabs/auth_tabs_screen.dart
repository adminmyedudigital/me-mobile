import 'package:flutter/material.dart';
import 'package:me_mobile/screens/screens.dart';

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

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const AuthLogo(),
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
                      : const SignUpForm(key: ValueKey('sign-up-form')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
