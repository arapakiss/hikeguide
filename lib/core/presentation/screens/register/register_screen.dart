import 'package:flutter/material.dart';
import 'widgets/register_form.dart';
import 'widgets/register_header.dart';
import 'widgets/register_footer.dart';
import 'package:hikeguide/core/presentation/screens/login/widgets/social_login_buttons.dart'; // import από login

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: const [
            RegisterHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    RegisterForm(),
                    SizedBox(height: 32),
                    SocialLoginButtons(),   // ✅ Προστέθηκαν τα κουμπιά Google / Apple
                    SizedBox(height: 32),
                    RegisterFooter(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
