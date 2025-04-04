import 'package:flutter/cupertino.dart';
import 'package:rohnewnotes/utilities/dialogs/generic_dialog.dart';

Future<void> showPasswordResetSentDialog (BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Password Reset',
    content: 'You would have received a password reset link. Please check your regsitered email for further steps',
    optionsBuilder: () => {
      'OK': null,
    }
  );
}