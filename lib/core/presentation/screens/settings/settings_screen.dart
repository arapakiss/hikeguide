import 'package:flutter/material.dart';
import 'package:hikeguide/services/auth_service.dart';
import 'package:hikeguide/services/firebase_auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hikeguide/features/splash/presentation/splash_quick.dart';
import 'package:hikeguide/core/presentation/screens/profile/account_screen.dart'; 
import 'package:cloud_functions/cloud_functions.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _handleLogout(BuildContext context) async {
    final authService = AuthService(FirebaseAuthProvider());

    await authService.logout();

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const SplashQuick()),
      (route) => false,
    );
  }

  Future<void> _revokeUserTokens(BuildContext context) async {
    try {
      final functions = FirebaseFunctions.instance;
      final callable = functions.httpsCallable('revokeUserTokens');
      await callable();
      await FirebaseAuth.instance.signOut();

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const SplashQuick()),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to logout from all devices: $e')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: theme.colorScheme.primary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Account'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const AccountScreen()),
    );// TODO: Navigate to Account Settings
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Privacy'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // TODO: Navigate to Privacy Settings
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.download),
            title: const Text('Export Data'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // TODO: Navigate to Export Data Page
            },
          ),
          const SizedBox(height: 40),
          Divider(color: theme.colorScheme.secondary),
          const SizedBox(height: 20),
          ListTile(
            leading: Icon(Icons.logout, color: theme.colorScheme.error),
            title: Text(
              'Logout',
              style: TextStyle(color: theme.colorScheme.error),
            ),
            onTap: () => _handleLogout(context),
          ),
          const SizedBox(height: 40),
Divider(color: theme.colorScheme.secondary),

const SizedBox(height: 40),
Divider(color: theme.colorScheme.secondary),
const SizedBox(height: 20),
ListTile(
  leading: Icon(Icons.phonelink_erase, color: theme.colorScheme.error),
  title: Text(
    'Logout from All Devices',
    style: TextStyle(color: theme.colorScheme.error),
  ),
  onTap: () async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('This will logout your account from ALL devices.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _revokeUserTokens(context);
    }
  },
),

        ],
      ),
    );
  }
}
