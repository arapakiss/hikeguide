import 'package:flutter/material.dart';

class ProfileFieldWidget extends StatelessWidget {
  final String label;
  final String value;
  final bool isEditable;
  final bool inEditMode;
  final TextEditingController? controller;

  const ProfileFieldWidget({
    Key? key,
    required this.label,
    required this.value,
    required this.isEditable,
    required this.inEditMode,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (inEditMode && isEditable && controller != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
        ),
      );
    } else {
      return ListTile(
        title: Text(
          label,
          style: theme.textTheme.titleSmall?.copyWith(color: Colors.grey),
        ),
        subtitle: Row(
          children: [
            Expanded(
              child: Text(
                value.isNotEmpty ? value : 'Not set',
                style: theme.textTheme.bodyMedium,
              ),
            ),
            if (!isEditable)
              const Icon(Icons.lock, size: 18, color: Colors.grey),
          ],
        ),
      );
    }
  }
}
