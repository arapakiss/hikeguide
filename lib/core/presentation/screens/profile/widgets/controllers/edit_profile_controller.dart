import 'package:flutter/material.dart';

class EditProfileController extends ChangeNotifier {
  bool isEditMode = false;

  void enterEditMode() {
    isEditMode = true;
    notifyListeners();
  }

  void exitEditMode() {
    isEditMode = false;
    notifyListeners();
  }
}
