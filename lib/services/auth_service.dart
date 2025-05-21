import 'package:hikeguide/services/firebase_auth_provider.dart';
import 'package:hikeguide/services/auth_local_storage.dart';
import 'package:hikeguide/services/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuthProvider _provider;
  final AuthLocalStorage _localStorage = AuthLocalStorage();

  AuthService(this._provider);

  Future<UserModel> login(String email, String password) async {
    final user = await _provider.login(email, password);
    await _localStorage.saveUser(user);
    return user;
  }

  Future<UserModel> register(String email, String password, String username) async {
    final user = await _provider.register(email, password, username);
    await _localStorage.saveUser(user);
    return user;
  }

  Future<UserModel> loginWithGoogle() async {
    final user = await _provider.loginWithGoogle();
    await _localStorage.saveUser(user);
    return user;
  }

  Future<UserModel> loginAnonymously() async {
    final user = await _provider.loginAnonymously();
    await _localStorage.saveUser(user);
    return user;
  }

  Future<void> sendPasswordReset(String email) {
    return _provider.sendPasswordReset(email);
  }

  Future<void> logout() async {
    await _provider.logout();
    await _localStorage.clearUser();
  }

  Future<UserModel?> getCurrentUser() {
    return _provider.getCurrentUser();
  }

  Future<UserModel?> getLocalUser() async {
    return await _localStorage.loadUser();
  }

  Future<bool> isUsernameAvailable(String username) {
    return _provider.isUsernameAvailable(username);
  }

  Future<void> updateUserProfile(UserModel updatedUser) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    throw Exception('No authenticated user.');
  }

  final firestore = FirebaseFirestore.instance;
  final localStorage = AuthLocalStorage();

  // Update στο Firestore
  await firestore.collection('users').doc(user.uid).update({
    'username': updatedUser.username ?? '',
  });

  // Update στο Hive Local Storage
  await localStorage.saveUser(updatedUser);

  print('🟢 Username updated in Firestore and local Hive.');
}

}
