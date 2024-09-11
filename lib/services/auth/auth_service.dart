import 'package:rohnewnotes/services/auth/auth_user.dart';
import 'package:rohnewnotes/services/auth/firebase_auth_provider.dart';
import 'auth_provider.dart';
// import 'package:firebase_auth/firebase_auth.dart' ;


class AuthService implements AuthProvider {
  @override
  Future<void> initialize() => provider.initialize();

  final AuthProvider provider;
  const AuthService(this.provider);

  factory AuthService.firebase() => AuthService(FirebaseAuthProvider() as AuthProvider,);


  @override
  Future<AuthUser?> createUser({
    required String email,
    required String password,
  }) =>
      provider.createUser(
        email: email,
        password: password,
      );

  @override
  AuthUser get currentUser => provider.currentUser!;

  @override
  Future<AuthUser?> logIn({
    required String email,
    required String password,
  }) =>
      provider.logIn(
        email: email,
        password: password,
      );

  @override
  Future<void> logOut() => provider.logOut();

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();

  @override
  // TODO: implement providerId
  String get providerId => 'firebase';
}