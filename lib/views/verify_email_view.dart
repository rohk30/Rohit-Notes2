import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rohnewnotes/constants/routes.dart';
import 'package:rohnewnotes/services/auth/auth_service.dart';
import 'package:rohnewnotes/services/auth/bloc/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rohnewnotes/services/auth/bloc/auth_events.dart';


class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Email'),),
      body: Column ( children: [
        const Text("A verification link has been sent to your mail."),
        const Text("Haven't received it yet?? Please click on this button!!"),
        TextButton(onPressed: () {
          context.read<AuthBloc>().add(const AuthEventSendEmailVerification());
        },
            child: const Text('Send email verification'),
        ),
        TextButton(
          onPressed: () async {
            context.read<AuthBloc>().add(const AuthEventLogOut());
          },
          child: const Text("Restart"),
        )
      ],),
    );
  }
}
