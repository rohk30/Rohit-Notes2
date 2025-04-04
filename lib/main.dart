import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rohnewnotes/constants/routes.dart';
import 'package:rohnewnotes/services/auth/auth_service.dart';import 'package:rohnewnotes/services/auth/bloc/auth_bloc.dart';
import 'package:rohnewnotes/services/auth/bloc/auth_events.dart';
import 'package:rohnewnotes/services/auth/bloc/auth_state.dart';
import 'package:rohnewnotes/services/auth/firebase_auth_provider.dart';
import 'package:rohnewnotes/views/forgot_password_view.dart';
import 'package:rohnewnotes/views/login_view.dart';
import 'package:rohnewnotes/views/notes/notes_view.dart';
import 'package:rohnewnotes/views/notes/create_update_note_view.dart';
import 'package:rohnewnotes/views/register_view.dart';
import 'package:rohnewnotes/views/verify_email_view.dart';

import 'helpers/loading/loading_screen.dart';

/*void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: const HomePage(),
      ),
      routes: {

        createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
      },
    ),
  );
} */

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      // supportedLocales: AppLocalizations.supportedLocales,
      // localizationsDelegates: AppLocalizations.localizationsDelegates,
      title: 'Flutter Demo',
      // debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: const HomePage(),
      ),
      routes: {
        createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(
            context: context,
            text: state.loadingText ?? 'Please wait a moment',
          );
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const NotesView();
        } else if (state is AuthStateNeedsVerification) {
          return const VerifyEmailView();
        } else if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else if (state is AuthStateForgotPassword) {
          return const ForgotPasswordView();
        } else if (state is AuthStateRegistering) {
          return const RegisterView();
        } else {
          return const Scaffold(
            body: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}


/*class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(AuthEventInitialize());
    return BlocBuilder(builder: (context, state) {
      if (state is AuthStateLoggedIn) {
        return const NotesView();
      } else if (state is AuthStateLoggedOut) {
        return const LoginView();
      } else if (state is AuthStateNeedsVerification) {
        return const VerifyEmailView();
      } else if (state is AuthStateRegistering) {
        return const RegisterView();
      } else {
        return const Scaffold(
          body: CircularProgressIndicator(),
        );
      }
    });


  }
}   */