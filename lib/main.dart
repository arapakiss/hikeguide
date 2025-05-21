import 'package:flutter/material.dart';
import 'package:hikeguide/bootstrap.dart'; // import το bootstrap που γράψαμε

void main() async {
  final Widget app = await bootstrap();
  runApp(app);
}
