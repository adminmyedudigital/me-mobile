import 'package:flutter/material.dart';

class AppDetailRow extends StatelessWidget {
  const AppDetailRow({
    required this.icon,
    required this.label,
    required this.value,
    super.key,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      minVerticalPadding: 0,
      leading: Icon(icon),
      title: Text(label),
      subtitle: Text(value, maxLines: 1, overflow: TextOverflow.ellipsis),
    );
  }
}
