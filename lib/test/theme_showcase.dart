import 'package:flutter/material.dart';
import 'package:hikeguide/shared/theme/app_theme.dart';

class ThemeShowcaseApp extends StatelessWidget {
  const ThemeShowcaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme:       buildTheme(Brightness.light),
      darkTheme:   buildTheme(Brightness.dark),
      home: const ThemeShowcaseScreen(),
    );
  }
}

/// Visual samples for every global style.
class ThemeShowcaseScreen extends StatelessWidget {
  const ThemeShowcaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Theme Showcase')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text('displayLarge', style: t.displayLarge),
            Text('headlineMedium', style: t.headlineMedium),
            Text('bodyLarge', style: t.bodyLarge),
            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: () {},
              child: const Text('ElevatedButton'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () {},
              child: const Text('OutlinedButton'),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {},
              child: const Text('TextButton'),
            ),

            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Card with default elevation & radius', style: t.bodyLarge),
              ),
            ),

            const SizedBox(height: 24),
            const TextField(
              decoration: InputDecoration(
                labelText: 'InputDecoration demo',
                hintText: 'Type something…',
              ),
            ),

            const SizedBox(height: 24),
            NavigationBar(
              selectedIndex: 1,
              onDestinationSelected: (_) {},
              destinations: const [
                NavigationDestination(icon: Icon(Icons.map_outlined), label: 'Explore'),
                NavigationDestination(icon: Icon(Icons.schedule), label: 'Timeline'),
                NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profile'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
