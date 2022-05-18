import 'package:bethel_smallholding/common_widgets/show_alert_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<void> showExceptionAlertDialog(
  BuildContext context, {
  required String title,
  required Exception exception,
}) =>
    showAlertDialog(
      context,
      title: title,
      content: _message(exception),
      defaultAction: AlertAction(text: "OK"),
    );

String _message(Exception exception) {
  if (exception is FirebaseException) {
    return exception.message ?? "Unknown Firebase Exception";
  }
  return exception.toString();
}
