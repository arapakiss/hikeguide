import 'package:flutter/material.dart';
import 'package:hikeguide/services/prefs_service.dart';
import 'package:hikeguide/core/presentation/screens/login/login_screen.dart'; // import it

class SplashLong extends StatefulWidget {
  const SplashLong({Key? key}) : super(key: key);

  @override
  State<SplashLong> createState() => _SplashLongState();
}

class _SplashLongState extends State<SplashLong> {
  final PrefsService _prefs = PrefsService();

  @override
  void initState() {
    super.initState();
    _startTransition();
  }

  Future<void> _startTransition() async {
    print('🔵 SplashLong: Showing long intro');

    await Future.delayed(const Duration(seconds: 4)); // Longer intro

    await _prefs.markFirstLaunchDone();
    print('🟢 SplashLong: Marked first launch done');

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginScreen()), // ✅ Σωστό επόμενο
    );
  }

@override
Widget build(BuildContext context) {
  return const Scaffold(
    backgroundColor: Colors.black,
    body: Center(
      child: Text(
        'Promo Intro',
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ),
  );
}

}
