import 'package:hikeguide/services/prefs_service.dart';

enum LaunchDestination {
  onboarding,
  login,
  home,
}

class AppStateManager {
  final PrefsService prefs;

  AppStateManager(this.prefs);

  Future<LaunchDestination> getInitialScreen() async {
    final firstLaunch = await prefs.isFirstLaunch();

    if (firstLaunch) {
      return LaunchDestination.onboarding;
    }

    // TODO: εδώ αργότερα θα βάλεις έλεγχο login:
    // bool loggedIn = await prefs.isLoggedIn();
    // return loggedIn ? LaunchDestination.home : LaunchDestination.login;

    return LaunchDestination.login;
  }
}
