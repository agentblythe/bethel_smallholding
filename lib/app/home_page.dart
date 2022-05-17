import 'package:bethel_smallholding/common_widgets/show_alert_dialog.dart';
import 'package:bethel_smallholding/services/auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final AuthBase auth;

  const HomePage({
    Key? key,
    required this.auth,
  }) : super(key: key);

  Future<void> _signOut() async {
    try {
      await auth.signOut();
    } catch (e) {
      print("Sign-out failed with exception: ${e.toString()}");
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await showAlertDialog(
      context,
      title: "Sign out confirmation",
      content: "Are you sure you want to sign out?",
      defaultAction: AlertAction(text: "Sign out", destructive: true),
      cancelAction: AlertAction(text: "Cancel"),
    );

    if (didRequestSignOut == true) {
      _signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
        actions: <Widget>[
          TextButton(
            onPressed: () => _confirmSignOut(context),
            child: const Text(
              "Logout",
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}
