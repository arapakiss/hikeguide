import 'package:flutter/material.dart';
import 'package:hikeguide/services/auth_service.dart';
import 'package:hikeguide/services/firebase_auth_provider.dart';
import 'package:hikeguide/services/user_model.dart';

class MockAuthTestScreen extends StatefulWidget {
  const MockAuthTestScreen({super.key});

  @override
  State<MockAuthTestScreen> createState() => _MockAuthTestScreenState();
}

class _MockAuthTestScreenState extends State<MockAuthTestScreen> {
  final AuthService authService = AuthService(FirebaseAuthProvider());
  UserModel? _user;
  String _status = "Idle";

  @override
  void initState() {
    super.initState();
    _loadLocalUser();
  }

  Future<void> _loadLocalUser() async {
    final user = await authService.getLocalUser();
    setState(() {
      _user = user;
    });
  }

  Future<void> _anonymousLogin() async {
    setState(() => _status = "Logging in anonymously...");
    final user = await authService.loginAnonymously();
    setState(() {
      _user = user;
      _status = "Anonymous login successful!";
    });
  }

  Future<void> _registerLogin() async {
    setState(() => _status = "Registering...");
    try {
      final user = await authService.register(
        "testuser@example.com",
        "securepassword",
        "TestUser",
      );
      setState(() {
        _user = user;
        _status = "Register/Login successful!";
      });
    } catch (e) {
      setState(() => _status = "Register/Login error: $e");
    }
  }

  Future<void> _logout() async {
    setState(() => _status = "Logging out...");
    await authService.logout();
    setState(() {
      _user = null;
      _status = "Logged out.";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mock Auth Test'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Status: $_status', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _anonymousLogin,
              child: const Text('Login Anonymously'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _registerLogin,
              child: const Text('Register/Login (Email/Pass)'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _logout,
              child: const Text('Logout'),
            ),
            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 16),
            Text(
              _user != null
                  ? 'Current User:\nUID: ${_user!.uid}\nEmail: ${_user!.email ?? "-"}\nUsername: ${_user!.username ?? "-"}'
                  : 'No local user loaded.',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
