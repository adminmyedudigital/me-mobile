import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:me_mobile/services/services.dart';
import 'package:me_mobile/theme/theme.dart';
import 'package:me_mobile/widgets/widgets.dart';

class SignUpWeb extends StatelessWidget {
  const SignUpWeb({super.key});

  Future<void> _openSignUp(BuildContext context) async {
    final opened = await launchUrl(
      Uri.parse(ApiRoutes.signUpWeb),
      mode: LaunchMode.externalApplication,
    );

    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to open the sign up page.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = context.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Create your ME account',
          style: textTheme.headlineSmall?.copyWith(
            color: colors.ink,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Visit our secure sign-up website to start your learning journey with a personalized student profile.',
          style: textTheme.bodyLarge?.copyWith(
            color: colors.body,
            letterSpacing: 0,
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        _SignUpBenefit(
          icon: Icons.shield,
          label: 'Fast, secure account creation',
          color: colors.primary,
        ),
        const SizedBox(height: AppSpacing.sm),
        _SignUpBenefit(
          icon: Icons.dashboard,
          label: 'Personalized dashboard access',
          color: colors.primary,
        ),
        const SizedBox(height: AppSpacing.sm),
        _SignUpBenefit(
          icon: Icons.schedule,
          label: 'Class schedules, timetables and more',
          color: colors.primary,
        ),
        const SizedBox(height: AppSpacing.xxl),
        MEButton(
          label: 'Open Sign Up',
          onPressed: () => _openSignUp(context),
          fullWidth: true,
          icon: Icons.open_in_browser,
          backgroundColor: colors.accentOrange,
          foregroundColor: colors.ink,
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'This will open the sign up page in your browser.',
          style: textTheme.bodySmall?.copyWith(
            color: colors.charcoal,
            height: 1.4,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _SignUpBenefit extends StatelessWidget {
  const _SignUpBenefit({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = context.textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 32,
          width: 32,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.16),
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(
            label,
            style: textTheme.bodyMedium?.copyWith(
              color: colors.body,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
