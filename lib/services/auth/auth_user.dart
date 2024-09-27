import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/cupertino.dart';

@immutable
class AuthUser {
  // final String id;
  final bool isEmailVerified;
  final String? email;
  const AuthUser({
    required this.email,
    required this.isEmailVerified,
    // required this.id
  });

  factory AuthUser.fromFirebase(User user) => AuthUser(
      isEmailVerified: user.emailVerified,
      email: user.email,
      // id:user.uid,
  );

}