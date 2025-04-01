import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rohnewnotes/constants/routes.dart';
import 'package:rohnewnotes/services/auth/auth_service.dart';
// import 'package:rohnewnotes/utilities/show_error_dialog.dart';

import '../services/auth/auth_exceptions.dart';
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
    return
      Scaffold(
        appBar: AppBar(title: const Text('Register'),),
        body: Column (
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
              try {
                await AuthService.firebase().createUser(
                    email: email,
                    password: password
                );
                AuthService.firebase().sendEmailVerification();
                Navigator.of(context).pushNamedAndRemoveUntil(
                  verifyEmailRoute,
                    (route) => false,
                );
              } on WeakPasswordAuthException {
                await showErrorDialog(context, 'Weak password');
              } on EmailAlreadyInUseAuthException {
                await showErrorDialog(context, 'Email is already registered');
              } on InvalidEmailAuthException {
                await showErrorDialog(context, 'Invalid email');
              } on GenericAuthException {
                await showErrorDialog(context, 'Failed to register');
              }
            },
            child: const Text('Register'),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    loginRoute,
                    (route) => false
                );
              },
              child: const Text('Already registered? Login instead')
          )
        ],
        ),
      );
  }
}
