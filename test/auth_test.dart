import 'dart:developer';

import 'package:rohnewnotes/services/auth/auth_exceptions.dart';
import 'package:rohnewnotes/services/auth/auth_provider.dart';
import 'package:rohnewnotes/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group('Mock Authentication', () {
    late MockAuthProvider provider;

    setUp(() async {
      provider = MockAuthProvider();
      await provider.initialize();
      print('✅ Provider initialized.');
    });

    test('Should be able to be initialized', () {
      print('🔍 Checking initialization status...');
      expect(provider.isInitialized, true);
      print('✅ Provider is initialized.');
    });

    test('Should initialize in less than 2 seconds', () async {
      print('⏱ Measuring initialization time...');
      final stopwatch = Stopwatch()..start();
      final newProvider = MockAuthProvider();
      await newProvider.initialize();
      stopwatch.stop();
      print('🕒 Initialization took: ${stopwatch.elapsedMilliseconds} ms');
      expect(stopwatch.elapsed.inSeconds < 2, true);
    });

    test('Create user should delegate to login function', () async {
      print('👤 Creating user...');
      final user = await provider.createUser(
        email: 'test@test.com',
        password: 'password',
      );
      print('✅ User created: ${user.email}');
      expect(provider.currentUser, user);
    });

    test('Logged in user should be able to get verified', () async {
      print('🔐 Creating and logging in user...');
      await provider.createUser(email: 'test@test.com', password: 'password');
      print('📧 Sending email verification...');
      await provider.sendEmailVerification();
      print('✅ Email verified: ${provider.currentUser!.isEmailVerified}');
      expect(provider.currentUser!.isEmailVerified, true);
    });

    test('Should be able to logout and login again', () async {
      print('🔁 Creating and logging in user...');
      await provider.createUser(email: 'test@test.com', password: 'password');
      print('🚪 Logging out...');
      await provider.logOut();
      print('✅ Logged out, current user: ${provider.currentUser}');
      expect(provider.currentUser, isNull);

      print('🔓 Logging in again...');
      final user = await provider.logIn(
        email: 'test@test.com',
        password: 'password',
      );
      print('✅ Re-logged in as: ${user.email}');
      expect(provider.currentUser, user);
    });

    final testCases = [
      {
        'email': 'test@test.com',
        'password': 'password',
        'expectSuccess': true,
      },
      {
        'email': 'foo@bar.com',
        'password': 'password',
        'expectSuccess': false,
      },
      {
        'email': 'test@test.com',
        'password': 'foobar',
        'expectSuccess': false,
      },
    ];

    for (var testCase in testCases) {
      test(
          'Login test with email: ${testCase['email']} and password: ${testCase['password']}',
              () async {
            try {
              print('🔐 Trying login with ${testCase['email']}...');
              final user = await provider.logIn(
                email: testCase['email'].toString(),
                password: testCase['password'].toString(),
              );
              print('✅ Login success: ${user.email}');
              expect(testCase['expectSuccess'], true);
            } catch (e) {
              print('❌ Login failed with error: $e');
              expect(testCase['expectSuccess'], false);
            }
          });
    }
  });
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;

  var _isInitialized = false;
  bool get isInitialized => _isInitialized;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw NotInitializedException();
    print('⏳ Simulating user creation delay...');
    await Future.delayed(const Duration(seconds: 1));
    return logIn(email: email, password: password);
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    print('🔧 Initializing MockAuthProvider...');
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
    print('✅ MockAuthProvider initialized.');
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) {
    if (!isInitialized) throw NotInitializedException();
    if (email == 'foo@bar.com') throw UserNotFoundAuthException();
    if (password == 'foobar') throw UserNotFoundAuthException();
    const user = AuthUser(
      isEmailVerified: false,
      email: 'rohitkumar.birakayala@gmail.com',
      id: 'my_id',
    );
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) throw NotInitializedException();
    if (_user == null) throw UserNotFoundAuthException();
    print('🚪 Simulating logout delay...');
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) throw NotInitializedException();
    final user = _user;
    if (user == null) throw UserNotFoundAuthException();
    const newUser = AuthUser(
      isEmailVerified: true,
      id: 'my_id',
      email: 'rohitkumar.birakayala@gmail.com',
    );
    _user = newUser;
  }

  @override
  Future<void> sendPasswordReset({required String toEmail}) {
    throw UnimplementedError();
  }
}



/*
import 'package:rohnewnotes/services/auth/auth_exceptions.dart';
import 'package:rohnewnotes/services/auth/auth_provider.dart';
import 'package:rohnewnotes/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group('Mock Authentication', () {
    late MockAuthProvider provider;

    setUp(() async {
      provider = MockAuthProvider();
      await provider.initialize();
    });

    test('Should be able to be initialized', () {
      expect(provider.isInitialized, true);
    });

    // test('Should initialize in less than 2 seconds', () async {
    //   final stopwatch = Stopwatch()..start();
    //   final newProvider = MockAuthProvider();
    //   await newProvider.initialize();
    //   stopwatch.stop();
    //   expect(stopwatch.elapsed.inSeconds < 2, true);
    // });

    test('Should initialize in less than 2 seconds', () async {
      final stopwatch = Stopwatch()..start();
      final newProvider = MockAuthProvider();
      await newProvider.initialize();
      stopwatch.stop();
      print('Initialization took: ${stopwatch.elapsedMilliseconds} ms');
      expect(stopwatch.elapsed.inSeconds < 2, true);
    });


    test('Create user should delegate to login function', () async {
      final user = await provider.createUser(
        email: 'test@test.com',
        password: 'password',
      );
      expect(provider.currentUser, user);
    });

    test('Logged in user should be able to get verified', () async {
      await provider.createUser(email: 'test@test.com', password: 'password');
      await provider.sendEmailVerification();
      expect(provider.currentUser!.isEmailVerified, true);
    });

    test('Should be able to logout and login again', () async {
      await provider.createUser(email: 'test@test.com', password: 'password');
      await provider.logOut();
      expect(provider.currentUser, isNull);

      final user = await provider.logIn(
        email: 'test@test.com',
        password: 'password',
      );
      expect(provider.currentUser, user);
    });
  });
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;

  var _isInitialized = false;
  bool get isInitialized => _isInitialized;


  @override
  Future<AuthUser> createUser({
    required String email,
    required String password
  }) async {
      if(!isInitialized) throw NotInitializedException();
      await Future.delayed(const Duration(seconds: 1));
      return logIn(
          email: email,
          password: password
      );
  }

  @override
  AuthUser? get currentUser => _user;

  // @override
  // Future<void> initialize() async{
  //   await Future.delayed(const Duration(seconds: 1));
  // }

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true; // This was missing
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password
  }) {
    if(!isInitialized) throw NotInitializedException();
    if(email == 'foo@bar.com')  throw UserNotFoundAuthException();
    if(password == 'foobar')  throw UserNotFoundAuthException();
    const user = AuthUser(
      isEmailVerified: false,
      email: 'rohitkumar.birakayala@gmail.com',
      id: 'my_id'
    );
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async{
    if(!isInitialized) throw NotInitializedException();
    if(_user == null)   throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if(!isInitialized) throw NotInitializedException();
    final user = _user;
    if(user == null) throw UserNotFoundAuthException();
    const newUser = AuthUser(
        isEmailVerified: true,
        id: 'my_id',
        email: 'rohitkumar.birakayala@gmail.com',
    );
    _user = newUser;
  }

  @override
  Future<void> sendPasswordReset({required String toEmail}) {
    // TODO: implement sendPasswordReset
    throw UnimplementedError();
  }
}
*/