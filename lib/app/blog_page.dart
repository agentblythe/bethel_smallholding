import 'package:bethel_smallholding/common_widgets/show_alert_dialog.dart';
import 'package:bethel_smallholding/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BlogPage extends StatelessWidget {
  const BlogPage({
    Key? key,
  }) : super(key: key);

  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
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
      _signOut(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Blog"),
        actions: <Widget>[
          TextButton(
            onPressed: () => _confirmSignOut(context),
            child: const Text(
              "Sign out",
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
