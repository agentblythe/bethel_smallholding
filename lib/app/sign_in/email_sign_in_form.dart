import 'package:bethel_smallholding/common_widgets/custom_elevated_button.dart';
import 'package:bethel_smallholding/common_widgets/form_submit_button.dart';
import 'package:flutter/material.dart';

class EmailSignInForm extends StatelessWidget {
  EmailSignInForm({Key? key}) : super(key: key);

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void _submit() {
    print(emailController.text);
    print(passwordController.text);
  }

  List<Widget> _buildChildren() {
    return [
      TextField(
        controller: emailController,
        decoration: const InputDecoration(
          labelText: "Email",
          hintText: "test@test.com",
        ),
      ),
      const SizedBox(height: 8),
      TextField(
        controller: passwordController,
        decoration: const InputDecoration(
          labelText: "Password",
        ),
        obscureText: true,
      ),
      const SizedBox(height: 8),
      FormSubmitButton(
        text: "Sign in",
        callback: _submit,
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
