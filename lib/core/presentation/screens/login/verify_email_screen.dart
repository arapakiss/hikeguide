import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hikeguide/core/presentation/screens/home/home_screen.dart';
import 'package:hikeguide/shared/widgets/error_message_box.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  bool isSending = false;
  bool isRefreshing = false;
  String? errorMessage;

  Future<void> _sendVerificationEmail() async {
    setState(() {
      isSending = true;
      errorMessage = null;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      await user?.sendEmailVerification();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Verification email sent!')),
      );
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to send verification email.';
      });
    } finally {
      setState(() {
        isSending = false;
      });
    }
  }

  Future<void> _checkEmailVerified() async {
    setState(() {
      isRefreshing = true;
      errorMessage = null;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      await user?.reload();
      final refreshedUser = FirebaseAuth.instance.currentUser;

      if (refreshedUser != null && refreshedUser.emailVerified) {
        if (!mounted) return;
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (route) => false,
        );
      } else {
        setState(() {
          errorMessage = 'Email not verified yet. Please check your inbox.';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to check email verification.';
      });
    } finally {
      setState(() {
        isRefreshing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Your Email'),
        backgroundColor: theme.colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 24),
            const Icon(Icons.email_outlined, size: 100),
            const SizedBox(height: 24),
            const Text(
              'A verification email has been sent to your email address.\nPlease verify to continue.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            if (errorMessage != null) ...[
              const SizedBox(height: 16),
              ErrorMessageBox(message: errorMessage!),
            ],
            const Spacer(),
            ElevatedButton.icon(
              onPressed: isSending ? null : _sendVerificationEmail,
              icon: const Icon(Icons.send),
              label: isSending
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Resend Email'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: isRefreshing ? null : _checkEmailVerified,
              icon: const Icon(Icons.refresh),
              label: isRefreshing
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('I\'ve Verified'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
