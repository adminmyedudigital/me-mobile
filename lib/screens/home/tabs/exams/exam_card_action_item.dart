part of 'exams_tab_card_actions.dart';

class _ExamCardActionItem extends StatelessWidget {
  const _ExamCardActionItem({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 19, color: color),
        const SizedBox(width: AppSpacing.sm),
        Text(label),
      ],
    );
  }
}
