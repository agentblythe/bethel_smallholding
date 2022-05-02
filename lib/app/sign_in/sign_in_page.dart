import 'package:flutter/material.dart';

import '../../common_widgets/custom_elevated_button.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bethel Smallholding'),
        elevation: 2.0,
      ),
      body: _buildContent(),
      backgroundColor: Colors.grey[200],
    );
  }
}

Widget _buildContent() {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: const <Widget>[
        Text(
          "Sign in",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 32.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(
          height: 8,
        ),
        CustomElevatedButton(
          child: Text(
            "Sign in with Google",
            style: TextStyle(
              color: Colors.black87,
              fontSize: 15.0,
            ),
          ),
          color: Colors.white,
          borderRadius: 4.0,
          onPressed: _signInWithGoogle,
        )
      ],
    ),
  );
}

void _signInWithGoogle() {
  // TODO: Auth with Google
}
