import 'package:flutter/material.dart';
import 'package:bottom_bar_matu/bottom_bar_matu.dart';
import 'package:hikeguide/core/presentation/screens/profile/profile_screen.dart';
import 'package:hikeguide/core/presentation/screens/settings/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  final List<Widget> _screens = const [
    Center(child: Text('Home', style: TextStyle(fontSize: 24))),
    ProfileScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: _screens[_index],
      bottomNavigationBar: BottomBarBubble(
        selectedIndex: _index,
        color: theme.colorScheme.primary, // respect theme
        items:  [
          BottomBarItem(iconData: Icons.home, label: 'Home'),
          BottomBarItem(iconData: Icons.person, label: 'Profile'),
          BottomBarItem(iconData: Icons.settings, label: 'Settings'),
        ],
        onSelect: (index) {
          setState(() {
            _index = index;
          });
        },
      ),
    );
  }
}
