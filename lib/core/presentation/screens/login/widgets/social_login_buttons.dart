import 'package:flutter/material.dart';

class SocialLoginButtons extends StatelessWidget {
  const SocialLoginButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(height: 32),
        const Text('or'),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.g_mobiledata, size: 32),
              onPressed: () {
                // TODO: Google login
              },
            ),
            const SizedBox(width: 24),
            IconButton(
              icon: const Icon(Icons.apple, size: 28),
              onPressed: () {
                // TODO: Apple login
              },
            ),
          ],
        ),
      ],
    );
  }
}
