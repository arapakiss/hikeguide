import 'package:flutter/material.dart';
import 'package:hikeguide/core/presentation/screens/home/home_screen.dart';
import 'package:hikeguide/services/auth_service.dart';
import 'package:hikeguide/services/firebase_auth_provider.dart';
import 'package:hikeguide/shared/widgets/error_message_box.dart';
import 'package:hikeguide/core/presentation/screens/login/verify_email_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? errorMessage;
  double passwordStrength = 0.0;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _checkPasswordStrength(String password) {
    double strength = 0;

    if (password.length >= 8) strength += 0.25;
    if (RegExp(r'[A-Z]').hasMatch(password)) strength += 0.25;
    if (RegExp(r'[a-z]').hasMatch(password)) strength += 0.15;
    if (RegExp(r'[0-9]').hasMatch(password)) strength += 0.20;
    if (RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(password)) strength += 0.15;

    setState(() {
      passwordStrength = strength.clamp(0.0, 1.0);
    });
  }

  Future<void> _handleRegister() async {
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();
    final authService = AuthService(FirebaseAuthProvider());

    if (username.length < 3) {
      setState(() => errorMessage = 'Username must be at least 3 characters long.');
      return;
    }

    final available = await authService.isUsernameAvailable(username);
    if (!available) {
      setState(() => errorMessage = 'Username is already taken. Please choose another.');
      return;
    }

    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      setState(() => errorMessage = 'Please enter a valid email address.');
      return;
    }
    if (password != confirmPassword) {
      setState(() => errorMessage = 'Passwords do not match.');
      return;
    }
    if (passwordStrength < 0.75) {
      setState(() => errorMessage = 'Password is too weak. Make it stronger.');
      return;
    }

    try {
      final user = await authService.register(email, password, username);

      if (!mounted) return;

      if (user.isAnonymous) {
        // Αν κάποια στιγμή υποστηρίξουμε anonymous, πήγαινε Home απευθείας
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (route) => false,
        );
        return;
      }

      if (FirebaseAuth.instance.currentUser != null && FirebaseAuth.instance.currentUser!.emailVerified) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (route) => false,
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const VerifyEmailScreen()),
        );
      }
    } catch (e) {
      setState(() => errorMessage = 'Registration failed: ${e.toString()}');
    }
  }


  Color _getStrengthColor() {
    if (passwordStrength < 0.4) return Colors.red;
    if (passwordStrength < 0.7) return Colors.orange;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (errorMessage != null)
          ErrorMessageBox(message: errorMessage!),
        TextField(
          controller: _usernameController,
          decoration: const InputDecoration(
            labelText: 'Username',
            hintText: 'Create a username',
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _emailController,
          decoration: const InputDecoration(
            labelText: 'Email',
            hintText: 'Enter your email',
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _passwordController,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Password',
            hintText: 'Create a password',
          ),
          onChanged: _checkPasswordStrength,
        ),
        const SizedBox(height: 8),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: double.infinity,
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey.shade300,
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: passwordStrength,
            child: Container(
              decoration: BoxDecoration(
                color: _getStrengthColor(),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _confirmPasswordController,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Confirm Password',
            hintText: 'Re-enter your password',
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _handleRegister,
            child: const Text('Create Account'),
          ),
        ),
      ],
    );
  }
}
