import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> showEmailChangePopup(BuildContext context, String oldEmail, String newEmail) async {
  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Confirm Email Change'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('You are changing your email from:'),
          const SizedBox(height: 8),
          Text(oldEmail, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Text('To:'),
          const SizedBox(height: 8),
          Text(newEmail, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          const Text('You will need to verify the new email before it becomes active.'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            _startEmailVerification(context, newEmail);
          },
          child: const Text('Confirm'),
        ),
      ],
    ),
  );
}

Future<void> _startEmailVerification(BuildContext context, String newEmail) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('No authenticated user.')),
    );
    return;
  }

  try {
    await user.verifyBeforeUpdateEmail(newEmail);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Verification email sent! Please verify your new email.'),
      ),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to send verification email: $e')),
    );
  }
}
