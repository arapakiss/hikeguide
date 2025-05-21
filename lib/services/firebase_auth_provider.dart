import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'user_model.dart';

class FirebaseAuthProvider {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel> login(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return await _buildUserModel(credential.user!);
    } on FirebaseAuthException catch (e) {
      String error;
      switch (e.code) {
        case 'invalid-email':
          error = 'Invalid email address.';
          break;
        case 'user-disabled':
          error = 'User account has been disabled.';
          break;
        case 'user-not-found':
          error = 'No user found for that email.';
          break;
        case 'wrong-password':
          error = 'Incorrect password.';
          break;
        default:
          error = 'Authentication failed. Try again.';
      }
      throw Exception(error);
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }


  Future<UserModel> register(String email, String password, String username) async {
    final credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    final user = credential.user!;

    await user.sendEmailVerification();

    final userData = UserModel(
      uid: user.uid,
      email: user.email,
      username: username,
      language: 'en',
      isAnonymous: false,
    );

    await _firestore.collection('users').doc(user.uid).set(userData.toMap());

    return userData;
  }


  Future<bool> isUsernameAvailable(String username) async {
  final query = await _firestore
      .collection('users')
      .where('username', isEqualTo: username)
      .limit(1)
      .get();

  return query.docs.isEmpty;
}


  Future<UserModel> loginWithGoogle() async {
    final googleUser = await GoogleSignIn().signIn();
    final googleAuth = await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    final authResult = await _auth.signInWithCredential(credential);
    return await _buildUserModel(authResult.user!);
  }

  Future<UserModel> loginAnonymously() async {
    final credential = await _auth.signInAnonymously();
    return await _buildUserModel(credential.user!);
  }

  Future<void> sendPasswordReset(String email) {
    return _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<UserModel?> getCurrentUser() async {
    final user = _auth.currentUser;
    return user != null ? await _buildUserModel(user) : null;
  }

  Future<UserModel> _buildUserModel(User user) async {
    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (doc.exists) {
      return UserModel.fromMap(doc.data()!);
    } else {
      // Fallback: create anonymous model
      return UserModel(
        uid: user.uid,
        email: user.email,
        username: user.displayName ?? 'Anonymous',
        language: 'en',
        isAnonymous: user.isAnonymous,
      );
    }
  }
}
