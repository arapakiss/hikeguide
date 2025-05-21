import 'package:flutter/material.dart';
import 'package:hikeguide/features/splash/presentation/splash_quick.dart';
import 'package:hikeguide/core/presentation/screens/home/home_screen.dart';

class HikeGuideApp extends StatelessWidget {
  const HikeGuideApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HikeGuide',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(), // ή το custom buildTheme()
      darkTheme: ThemeData.dark(),
      home: const HomeScreen(), // ✅ ΕΔΩ είναι το κρίσιμο σημείο
    );
  }
}
