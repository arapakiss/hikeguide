import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'widgets/controllers/edit_profile_controller.dart';
import 'widgets/profile_field_widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EditProfileController(),
      child: const ProfileScreenContent(),
    );
  }
}

class ProfileScreenContent extends StatefulWidget {
  const ProfileScreenContent({super.key});

  @override
  State<ProfileScreenContent> createState() => _ProfileScreenContentState();
}

class _ProfileScreenContentState extends State<ProfileScreenContent> {
  final _usernameController = TextEditingController(text: 'CurrentUsername');
  final _emailController = TextEditingController(text: 'email@example.com');

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<EditProfileController>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        actions: [
          if (!controller.isEditMode)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: controller.enterEditMode,
            ),
          if (controller.isEditMode)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                // TODO: save changes logic
                controller.exitEditMode();
              },
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
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
            isEditable: true, // Special behavior θα μπει εδώ αργότερα
            inEditMode: controller.isEditMode,
            controller: _emailController,
          ),
          const Divider(),
          ProfileFieldWidget(
            label: 'User ID',
            value: 'UserUID12345',
            isEditable: false,
            inEditMode: controller.isEditMode,
          ),
        ],
      ),
    );
  }
}
