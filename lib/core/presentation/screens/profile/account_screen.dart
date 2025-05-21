import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hikeguide/core/presentation/screens/profile/widgets/controllers/edit_profile_controller.dart';
import 'package:hikeguide/core/presentation/screens/profile/widgets/profile_field_widget.dart';
import 'package:hikeguide/services/auth_service.dart';
import 'package:hikeguide/services/firebase_auth_provider.dart';
import 'package:hikeguide/services/user_model.dart';
import 'package:hikeguide/services/auth_local_storage.dart';
import 'package:hikeguide/core/presentation/screens/profile/change_password_screen.dart';
import 'widgets/email_verification_popup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EditProfileController(),
      child: const AccountScreenContent(),
    );
  }
}

class AccountScreenContent extends StatefulWidget {
  const AccountScreenContent({super.key});

  @override
  State<AccountScreenContent> createState() => _AccountScreenContentState();
}

class _AccountScreenContentState extends State<AccountScreenContent> {
  UserModel? _user;
  bool _isLoading = true;
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();

  Timer? _emailVerificationTimer;
  DateTime? _emailChangeStartedAt;
  bool _waitingForEmailVerification = false;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final authService = AuthService(FirebaseAuthProvider());
    final user = await authService.getLocalUser();
    debugPrint('🔵 Loaded user: ${user?.uid}');

    if (user != null) {
      _usernameController.text = user.username ?? '';
      _emailController.text = user.email ?? '';
    }
    setState(() {
      _user = user;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _emailVerificationTimer?.cancel();
    super.dispose();
  }

  void _startEmailVerificationTimer() {
    _emailVerificationTimer?.cancel();
    _emailChangeStartedAt = DateTime.now();
    _waitingForEmailVerification = true;

    _emailVerificationTimer = Timer.periodic(const Duration(seconds: 30), (timer) async {
      final now = DateTime.now();
      final elapsed = now.difference(_emailChangeStartedAt!).inMinutes;

      if (elapsed >= 5) {
        timer.cancel();
        _emailVerificationTimer = Timer.periodic(const Duration(minutes: 5), (_) => _checkEmailVerified());
        return;
      }

      await _checkEmailVerified();
    });

    debugPrint('🟡 Email Verification Timer started.');
  }

  Future<void> _checkEmailVerified() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await user.reload();
    final refreshedUser = FirebaseAuth.instance.currentUser;

    if (refreshedUser != null && refreshedUser.emailVerified) {
      debugPrint('🟢 Email verified! Updating local user.');

      final authLocalStorage = AuthLocalStorage();
      final firestore = FirebaseFirestore.instance;

      final updatedUser = _user!.copyWith(email: refreshedUser.email ?? _user!.email);
      await authLocalStorage.saveUser(updatedUser);
      await firestore.collection('users').doc(refreshedUser.uid).update({
        'email': refreshedUser.email,
      });

      setState(() {
        _user = updatedUser;
        _waitingForEmailVerification = false;
      });

      _emailVerificationTimer?.cancel();
      _emailVerificationTimer = null;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Email verified and updated!')),
      );
    } else {
      debugPrint('🔵 Email not verified yet...');
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<EditProfileController>(context);
    final theme = Theme.of(context);

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Account'),
          backgroundColor: theme.colorScheme.primary,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Account'),
          backgroundColor: theme.colorScheme.primary,
        ),
        body: const Center(
          child: Text('No user found.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        backgroundColor: theme.colorScheme.primary,
        actions: [
          if (!controller.isEditMode)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: controller.enterEditMode,
            ),
          if (controller.isEditMode)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () async {
                final newUsername = _usernameController.text.trim();
                final newEmail = _emailController.text.trim();
                final oldUsername = _user?.username ?? '';
                final oldEmail = _user?.email ?? '';

                if (newUsername == oldUsername && newEmail == oldEmail) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('No changes to save.')),
                  );
                  context.read<EditProfileController>().exitEditMode();
                  return;
                }

                try {
                  final authService = AuthService(FirebaseAuthProvider());

                  if (newUsername != oldUsername) {
                    debugPrint('🟡 Username changed, saving...');
                    final updatedUser = _user!.copyWith(username: newUsername);
                    await authService.updateUserProfile(updatedUser);
                    setState(() {
                      _user = updatedUser;
                    });
                  }

                  if (newEmail != oldEmail) {
                    debugPrint('🟠 Email changed, need verification...');
                    if (!mounted) return;
                    await showEmailChangePopup(context, oldEmail, newEmail);
                    _startEmailVerificationTimer();
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Changes saved successfully!')),
                  );
                  context.read<EditProfileController>().exitEditMode();
                } catch (e) {
                  debugPrint('🔴 Failed to save changes: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to save changes: $e')),
                  );
                }
              },
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const SizedBox(height: 16),
          ProfileFieldWidget(
            label: 'Username',
            value: _usernameController.text,
            isEditable: true,
            inEditMode: controller.isEditMode,
            controller: _usernameController,
          ),
          const Divider(),
          ProfileFieldWidget(
            label: 'Email',
            value: _emailController.text,
            isEditable: true,
            inEditMode: controller.isEditMode,
            controller: _emailController,
          ),
          const Divider(),
          ProfileFieldWidget(
            label: 'User ID',
            value: _user!.uid,
            isEditable: false,
            inEditMode: controller.isEditMode,
          ),
          const Divider(),
          ProfileFieldWidget(
            label: 'Status',
            value: _user!.isAnonymous ? 'Anonymous' : 'Registered',
            isEditable: false,
            inEditMode: controller.isEditMode,
          ),
          const Divider(height: 48),
          ListTile(
            leading: const Icon(Icons.lock_reset),
            title: const Text('Change Password'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ChangePasswordScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
