import 'package:bloc/bloc.dart';
import 'package:rohnewnotes/services/auth/bloc/auth_events.dart';
import 'package:rohnewnotes/services/auth/bloc/auth_state.dart';

import '../auth_provider.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider) : super(const AuthStateLoading()) {

    //initialize
    on<AuthEventInitialize>((event, emit) async {
      await provider.initialize();
      final user = provider.currentUser;
      if(user == null) {
        emit(const AuthStateLoggedOut());
      } else if(!user.isEmailVerified) {
        emit(const AuthStateNeedsVerification());
      } else {
        emit(AuthStateLoggedIn(user));
      }
    });

    //Log in
    on<AuthEventLogIn>((event, emit) async {
      emit(AuthStateLoading());
      final email = event.email;
      final password = event.password;
      try {
        final user = await provider.logIn(
            email: email,
            password: password
        );
        emit(AuthStateLoggedIn(user));
      } on Exception catch (e) {
        emit(AuthStateLogInFailure(e));
      }
    });

    //Log Out
    on<AuthEventLogOut>((event, emit) async {
      try {
        emit(AuthStateLoading());
        await provider.logOut();
        emit(AuthStateLoggedOut());
      } on Exception catch(e) {
        emit(AuthStateLogOutFailure(e));
      }
    });
  }

  // AuthBloc(AuthProvider provider) : super (const AuthStateLoading()) {
  //   on<AuthEventInitialize>((event, emit) async {
  //     await provider.initialize();
  //     final user = provider.currentuser;
  //   });
  // }
}