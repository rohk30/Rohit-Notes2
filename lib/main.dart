import 'package:flutter/material.dart';
import 'package:rohnewnotes/constants/routes.dart';
import 'package:rohnewnotes/services/auth/auth_service.dart';
import 'package:rohnewnotes/services/auth/auth_user.dart';
import 'package:rohnewnotes/views/login_view.dart';
import 'package:rohnewnotes/views/notes_view.dart';
import 'package:rohnewnotes/views/register_view.dart';
import 'package:rohnewnotes/views/verify_email_view.dart';
import 'dart:developer' as devtools show log;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        primarySwatch: Colors.blue,
        // backgroundColor: Colors.blue, // Set AppBar background color
        // foregroundColor: Colors.white,
        // useMaterial3: true,
      ),
      home: const HomePage(),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        notesRoute: (context) => const NotesView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: AuthService.firebase().initialize(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = AuthService.firebase().currentUser as AuthUser?;
              if (user != null) {
                if (user!.isEmailVerified) {
                  return const NotesView();
                } else {
                  return const VerifyEmailView();
                }
              } else {
                return const LoginView();
              }

            default:
              return const CircularProgressIndicator();
          }
        });
  }
}