import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rohnewnotes/constants/routes.dart';
import 'package:rohnewnotes/services/auth/auth_service.dart';
import 'package:rohnewnotes/services/auth/bloc/auth_events.dart';
// import 'package:rohnewnotes/utilities/show_error_dialog.dart';

import '../services/auth/auth_exceptions.dart';
import '../services/auth/bloc/auth_bloc.dart';
import '../services/auth/bloc/auth_state.dart';
import '../utilities/dialogs/error_dialog.dart';
// import 'dart:developer' as devtools show log;


class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    // TODO: implement initState
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
        listener: (context, state) async {
          if (state is AuthStateRegistering) {
            if(state.exception is WeakPasswordAuthException) {
              await showErrorDialog(context, 'Weak Password');
            } else if(state.exception is EmailAlreadyInUseAuthException) {
              await showErrorDialog(context, 'Email is Already in Use');
            } else if(state.exception is GenericAuthException) {
              await showErrorDialog(context, 'Failed to register');
            } else if(state.exception is InvalidEmailAuthException) {
              await showErrorDialog(context, 'Invalid Email');
            }
          }
        },
        child: Scaffold(
          appBar: AppBar(title: const Text('Register'),),
          body: Column(
            children: [
              TextField(
                controller: _email,
                enableSuggestions: false,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration:
                const InputDecoration(hintText: 'Enter your email here'),
              ),
              TextField(
                controller: _password,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration:
                const InputDecoration(hintText: 'Enter your password here'),
              ),
              TextButton(
                onPressed: () async {
                  final email = _email.text;
                  final password = _password.text;
                  context.read<AuthBloc>().add(AuthEventRegister(
                      email,
                      password
                  ));
                },
                child: const Text('Register'),
              ),
              TextButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(AuthEventLogOut(),);
                  },
                  child: const Text('Already registered? Login instead')
              )
            ],
          ),
        ),
      );
  }
}
