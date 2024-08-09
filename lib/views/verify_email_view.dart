import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rohnewnotes/constants/routes.dart';


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
        TextButton(onPressed: () async {
          final user = FirebaseAuth.instance.currentUser;
          await user?.sendEmailVerification();
        },
            child: const Text('Send email verification'),
        ),
        TextButton(
          onPressed: () async {
            FirebaseAuth.instance.signOut();
            Navigator.of(context).pushNamedAndRemoveUntil(registerRoute, (route)=>false);
          },
          child: const Text("Restart"),
        )
      ],),
    );
  }
}
