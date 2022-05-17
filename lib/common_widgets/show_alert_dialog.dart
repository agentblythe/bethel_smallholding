import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlertAction {
  final String text;
  final bool destructive;

  AlertAction({
    Key? key,
    required this.text,
    this.destructive = false,
  });
}

Future<bool?> showAlertDialog(
  BuildContext context, {
  required String title,
  required String content,
  required AlertAction defaultAction,
  AlertAction? cancelAction,
}) {
  if (!Platform.isIOS) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          if (cancelAction != null)
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                cancelAction.text,
                style: cancelAction.destructive == true
                    ? const TextStyle(color: Colors.red)
                    : null,
              ),
            ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              defaultAction.text,
              style: defaultAction.destructive == true
                  ? const TextStyle(color: Colors.red)
                  : null,
            ),
          )
        ],
      ),
    );
  } else {
    return showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          if (cancelAction != null)
            CupertinoDialogAction(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(cancelAction.text),
              isDestructiveAction: cancelAction.destructive,
            ),
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(defaultAction.text),
            isDestructiveAction: defaultAction.destructive,
          )
        ],
      ),
    );
  }
}
