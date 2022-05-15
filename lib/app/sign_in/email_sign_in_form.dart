import 'package:bethel_smallholding/common_widgets/custom_elevated_button.dart';
import 'package:bethel_smallholding/common_widgets/form_submit_button.dart';
import 'package:flutter/material.dart';

class EmailSignInForm extends StatelessWidget {
  const EmailSignInForm({Key? key}) : super(key: key);

  List<Widget> _buildChildren() {
    return [
      const TextField(
        decoration: InputDecoration(
          labelText: "Email",
          hintText: "test@test.com",
        ),
      ),
      const SizedBox(height: 8),
      const TextField(
        decoration: InputDecoration(
          labelText: "Password",
        ),
        obscureText: true,
      ),
      const SizedBox(height: 8),
      FormSubmitButton(
        text: "Sign in",
        callback: () {},
      ),
      const SizedBox(height: 8),
      TextButton(
        onPressed: () {},
        child: const Text("Need an account? Register"),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildChildren(),
      ),
    );
  }
}
