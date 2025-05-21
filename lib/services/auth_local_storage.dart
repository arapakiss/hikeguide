import 'package:hive/hive.dart';
import 'package:hikeguide/services/user_model.dart';

class AuthLocalStorage {
  static const String userBoxName = 'user_data';

  Future<void> saveUser(UserModel user) async {
    final box = await Hive.openBox<UserModel>(userBoxName);
    await box.put('current_user', user);
  }

  Future<UserModel?> loadUser() async {
    final box = await Hive.openBox<UserModel>(userBoxName);
    return box.get('current_user');
  }

  Future<void> clearUser() async {
    final box = await Hive.openBox<UserModel>(userBoxName);
    await box.delete('current_user');
  }
}
