// import 'dart:async';
import 'package:firebase_core/firebase_core.dart';

import '../../firebase_options.dart';
import 'package:rohnewnotes/services/auth/auth_user.dart';

abstract class AuthProvider {

  Future<void> initialize();

  AuthUser? get currentUser;

  Future<AuthUser> logIn({
    required String email,
    required String password,
  });

  Future<AuthUser> createUser({
    required String email,
    required String password,
  });

  Future<void> logOut();

  Future<void> sendEmailVerification();
}