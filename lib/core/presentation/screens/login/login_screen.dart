import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Προς το παρόν εμφανίζει μόνο ένα snackbar
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Login button pressed')),
            );
          },
          child: const Text('Login'),
        ),
      ),
    );
  }
}
