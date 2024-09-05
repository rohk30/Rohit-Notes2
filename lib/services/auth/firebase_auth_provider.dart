// import 'package: services/auth/auth_provider.dart';
// import 'package: services/auth/auth_user.dart';
// import 'package: services/auth/auth_exceptions.dart';
import 'dart:core';
import 'dart:async';
import 'dart:nativewrappers/_internal/vm/lib/core_patch.dart' hide String;

import 'package:firebase_auth/firebase_auth.dart'
  show AuthProvider, FirebaseAuth, FirebaseAuthException;
import 'package:rohnewnotes/services/auth/auth_exceptions.dart';
import 'package:rohnewnotes/services/auth/auth_user.dart';

class FirebaseAuthProvider implements AuthProvider {
  @override
  // TODO: implement providerId
  String get providerId => throw UnimplementedError();

  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if(user != null) {
      return AuthUser.fromFirebase(user);
    } else {
      return null;
    }
  }

  @override
  Future<AuthUser> createUser(
      {
    required String email,
    required String password,
  } ) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      final user = currentUser;
      if(user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch(e) {
      if(e.code == 'weak-password') {
        throw WeakPasswordAuthException();
      } else if(e.code == 'email-already-in-use') {
        throw EmailAlreadyInUseAuthException();
      } else if(e.code == 'invalid-email') {
        throw InvalidEmailAuthException();
      }
      else {
        throw GenericAuthException();
      }
    } catch (_) {
        throw GenericAuthException();
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if(user != null) {
      await user.sendEmailVerification();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      final user = currentUser;
      if(user!=null) {
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch(e) {
      if (e.code == 'user-not-found') {
        throw UserNotFoundAuthException();
      } else if (e.code == 'invalid-credential') {
        throw InvalidEmailAuthException();
      } else if (e.code == 'wrong-password') {
        throw WrongPasswordAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  Future<void> logOut() async {
    final user = FirebaseAuth.instance.currentUser;
    if(user != null) {
      await user.sendEmailVerification();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

}

