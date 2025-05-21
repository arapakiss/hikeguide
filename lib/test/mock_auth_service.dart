import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hikeguide/firebase_options.dart';
import 'package:hikeguide/services/auth_service.dart';
import 'package:hikeguide/services/firebase_auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final authService = AuthService(FirebaseAuthProvider());

  runApp(MockAuthTestApp(authService));
}

class MockAuthTestApp extends StatelessWidget {
  final AuthService authService;

  const MockAuthTestApp(this.authService, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _runTests();
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Running Mock Auth Tests...'),
        ),
      ),
    );
  }

  void _runTests() async {
    print('🛠️ Mock Test Started');

    try {
      print('🔵 Trying anonymous login...');
      final anonUser = await authService.loginAnonymously();
      print('✅ Anonymous User: ${anonUser.uid} | isAnonymous: ${anonUser.isAnonymous}');

      print('🟡 Trying register...');
      final registeredUser = await authService.register(
        'testuser@example.com',
        'securepassword',
        'TestUser',
      );
      print('✅ Registered User: ${registeredUser.username} | email: ${registeredUser.email}');

      print('🟢 Trying login...');
      final loggedInUser = await authService.login(
        'testuser@example.com',
        'securepassword',
      );
      print('✅ Logged In User: ${loggedInUser.username} | uid: ${loggedInUser.uid}');

      print('🔴 Trying logout...');
      await authService.logout();
      print('✅ User Logged Out');

    } catch (e) {
      print('❌ Error during test: $e');
    }

    print('✅ Mock Test Finished');
  }
}
