import 'package:flutter/material.dart';
import 'package:hikeguide/core/domain/app_state_manager.dart';
import 'package:hikeguide/services/prefs_service.dart';
import 'package:hikeguide/features/splash/presentation/splash_long.dart';
import 'package:hikeguide/core/presentation/screens/login/login_screen.dart';

class SplashQuick extends StatefulWidget {
  const SplashQuick({Key? key}) : super(key: key);

  @override
  State<SplashQuick> createState() => _SplashQuickState();
}

class _SplashQuickState extends State<SplashQuick> {
  final AppStateManager _stateManager = AppStateManager(PrefsService());

  @override
  void initState() {
    super.initState();
    _handleStartup();
  }

  Future<void> _handleStartup() async {
    print('🔵 SplashQuick: Waiting 2 seconds');
    await Future.delayed(const Duration(seconds: 2));

    final destination = await _stateManager.getInitialScreen();
    print('🟢 SplashQuick: Launch destination is $destination');

    Widget nextScreen;

    switch (destination) {
      case LaunchDestination.onboarding:
        print('➡️ Routing to SplashLong');
        nextScreen = const SplashLong();
        break;
      case LaunchDestination.home:
        print('➡️ Routing to Home (Placeholder)');
        nextScreen = const Placeholder();
        break;
      case LaunchDestination.login:
        print('➡️ Routing to LoginScreen');
        nextScreen = const LoginScreen();
        break;
    }

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => nextScreen),
    );
  }

@override
Widget build(BuildContext context) {
  return const Scaffold(
    backgroundColor: Colors.white,
    body: Center(
      child: Text(
        'Logo',
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    ),
  );
}

}
