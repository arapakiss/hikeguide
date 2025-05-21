import 'package:hive/hive.dart';

part 'user_model.g.dart'; // Αυτό δημιουργείται από το build_runner

@HiveType(typeId: 0)
class UserModel {
  @HiveField(0)
  final String uid;

  @HiveField(1)
  final String? email;

  @HiveField(2)
  final String? username;

  @HiveField(3)
  final String language;

  @HiveField(4)
  final bool isAnonymous;

  UserModel({
    required this.uid,
    this.email,
    this.username,
    required this.language,
    required this.isAnonymous,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      username: map['username'],
      language: map['language'] ?? 'en',
      isAnonymous: map['isAnonymous'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
      'language': language,
      'isAnonymous': isAnonymous,
    };
  }

  UserModel copyWith({
    String? email,
    String? username,
    String? language,
    bool? isAnonymous,
  }) {
    return UserModel(
      uid: uid, // το uid δεν αλλάζει ποτέ
      email: email ?? this.email,
      username: username ?? this.username,
      language: language ?? this.language,
      isAnonymous: isAnonymous ?? this.isAnonymous,
    );
  }
}
