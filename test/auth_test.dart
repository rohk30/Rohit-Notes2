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

    test('Should initialize in less than 2 seconds', () async {
      final stopwatch = Stopwatch()..start();
      final newProvider = MockAuthProvider();
      await newProvider.initialize();
      stopwatch.stop();
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



/*
void main() {
  group('Mock Authentication', () {
    final provider = MockAuthProvider();

    test('Should not be initialized to begin with:', (){
      expect(provider.isInitialized, false);
    });

    test('Cannot logout an uninitiliazed user', () {
      expect(
          provider.logOut(),
          throwsA(const TypeMatcher<NotInitializedException>()),
      );
    });

    test('Should be able to be initialized', () async{
      await provider.initialize();
      expect(provider.isInitialized, true);
    });

    test('User should be null', () {
      expect(provider.currentUser, null);
    });

    test('Should be able to initialize in less than 2 seconds', () async {
        await provider.initialize();
        expect(provider.isInitialized, true);
      },
      timeout: const Timeout(Duration(seconds: 2)),
    );

    test('Create user should delegate to logIn function', () async {
      final badEmailUser = provider.createUser(
        email: 'foo@bar.com',
        password: 'anypassword',
      );
      expect(
        badEmailUser,
        throwsA(const TypeMatcher<UserNotFoundAuthException>()));

      final badPasswordUser = provider.createUser(
          email: 'somone@gmail.com',
          password: 'foobar'
      );
      expect(badPasswordUser, throwsA(const TypeMatcher<WrongPasswordAuthException>()));

      final user = await provider.createUser(
        email: 'foo',
        password: 'bar',
      );
      expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);
    });

    test('Logged in user should be able to get verified', () {
      provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });

    test('Should be able to logout/ login', () async {
      await provider.logOut();
      await provider.logIn(email: 'email', password: 'password');
      final user = provider.currentUser;
      expect(user, isNotNull);
    });

  });
} */
