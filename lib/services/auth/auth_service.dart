// import 'package:';

import 'package:firebase_auth/firebase_auth.dart';

import 'auth_user.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;
  const AuthService(this.provider);

  @override
  // TODO: implement providerId
  String get providerId => throw UnimplementedError();

  @override
  // Future<AuthUser> createUser({
  //       required String email,
  //       required String password,
      // }) => provider.createUser(email: email, password: password,);

}