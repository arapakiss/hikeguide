import 'package:flutter/material.dart';
import 'widgets/forgot_password_form.dart';
import 'widgets/forgot_password_header.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
        backgroundColor: theme.colorScheme.primary,
      ),
      body: const SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ForgotPasswordHeader(),
              SizedBox(height: 32),
              ForgotPasswordForm(),
            ],
          ),
        ),
      ),
    );
  }
}
