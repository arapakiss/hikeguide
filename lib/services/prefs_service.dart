import 'package:shared_preferences/shared_preferences.dart';

class PrefsService {
  static const _firstLaunchKey = 'first_launch';

  /// true την πρώτη εκκίνηση, false στις επόμενες
  Future<bool> isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_firstLaunchKey) ?? true;
  }

  /// κάλεσέ το μόλις τελειώσει το long splash/onboarding
  Future<void> markFirstLaunchDone() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_firstLaunchKey, false);
  }
}
