import 'package:flutter/material.dart';
import 'package:hikeguide/core/presentation/screens/login/login_screen.dart';

class RegisterFooter extends StatelessWidget {
  const RegisterFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Already have an account?'),
        TextButton(
          onPressed: () {
              Navigator.of(context).pushReplacement(
           MaterialPageRoute(builder: (_) => const LoginScreen()),
         );// TODO: Navigator.pop() or push LoginScreen
          },
          child: const Text('Login'),
        ),
      ],
    );
  }
}
