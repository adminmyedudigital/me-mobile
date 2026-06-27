import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:me_mobile/theme/theme.dart';

class AuthLogo extends StatefulWidget {
  const AuthLogo({super.key, required this.currentIndex});

  final int currentIndex;

  @override
  State<AuthLogo> createState() => _AuthLogoState();
}

class _AuthLogoState extends State<AuthLogo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _motion;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3600),
    )..repeat();
    _motion = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isSignIn = widget.currentIndex == 0;
    final title = isSignIn ? 'Sign in' : 'Create account';
    final subtitle = isSignIn
        ? 'Welcome back to your account'
        : 'Start your journey with us';

    return Align(
      alignment: Alignment.centerLeft,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 560),
        curve: Curves.easeOutCubic,
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, 10 * (1 - value)),
              child: Transform.scale(
                scale: 0.96 + (0.04 * value),
                alignment: Alignment.centerLeft,
                child: child,
              ),
            ),
          );
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final float = math.sin(_controller.value * math.pi * 2) * 1.5;

                return Transform.translate(
                  offset: Offset(0, float),
                  child: child,
                );
              },
              child: SizedBox(
                width: 94,
                height: 94,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: _motion,
                      builder: (context, _) {
                        final pulse =
                            0.18 +
                            (math.sin(_controller.value * math.pi * 2) + 1) *
                                0.035;

                        return Container(
                          width: 76,
                          height: 76,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: colors.accentOrangeGlow.withValues(
                                  alpha: pulse,
                                ),
                                blurRadius: 24,
                                spreadRadius: 1,
                              ),
                              BoxShadow(
                                color: colors.link.withValues(alpha: 0.1),
                                blurRadius: 18,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    RotationTransition(
                      turns: _controller,
                      child: CustomPaint(
                        size: const Size.square(88),
                        painter: _LogoOrbitPainter(
                          link: colors.link,
                          accent: colors.accentOrangeGlow,
                          hairline: colors.hairlineStrong,
                        ),
                      ),
                    ),
                    Container(
                      width: 74,
                      height: 74,
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: colors.ink.withValues(alpha: 0.1),
                        ),
                      ),
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.contain,
                        semanticLabel: 'ME Digital logo',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeIn,
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.18),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: Column(
                    key: ValueKey(title),
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTypography.headingSm(
                          colors,
                        ).copyWith(height: 1.05, letterSpacing: 0),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        subtitle,
                        style: AppTypography.captionEmph(
                          colors,
                        ).copyWith(color: colors.charcoal),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Container(
                  width: 78,
                  height: 3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    gradient: LinearGradient(
                      colors: [
                        colors.link.withValues(alpha: 0.72),
                        colors.accentOrangeGlow.withValues(alpha: 0.42),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LogoOrbitPainter extends CustomPainter {
  const _LogoOrbitPainter({
    required this.link,
    required this.accent,
    required this.hairline,
  });

  final Color link;
  final Color accent;
  final Color hairline;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final center = rect.center;
    final radius = (size.shortestSide - 8) / 2;
    final orbitRect = Rect.fromCircle(center: center, radius: radius);

    final trackPaint = Paint()
      ..color = hairline
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawCircle(center, radius, trackPaint);

    final orbitPaint = Paint()
      ..shader = SweepGradient(
        colors: [
          Colors.transparent,
          link.withValues(alpha: 0.75),
          accent.withValues(alpha: 0.65),
          Colors.transparent,
        ],
        stops: const [0, 0.48, 0.72, 1],
      ).createShader(orbitRect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(orbitRect, -math.pi / 2, math.pi * 1.45, false, orbitPaint);
  }

  @override
  bool shouldRepaint(covariant _LogoOrbitPainter oldDelegate) {
    return oldDelegate.link != link ||
        oldDelegate.accent != accent ||
        oldDelegate.hairline != hairline;
  }
}
