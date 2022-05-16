import 'package:bethel_smallholding/common_widgets/custom_elevated_button.dart';
import 'package:bethel_smallholding/common_widgets/form_submit_button.dart';
import 'package:bethel_smallholding/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum EmailSignInFormType {
  signIn,
  register,
}

class EmailSignInForm extends StatefulWidget {
  final AuthBase auth;

  const EmailSignInForm({
    Key? key,
    required this.auth,
  }) : super(key: key);

  @override
  State<EmailSignInForm> createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String get _email => _emailController.text;
  String get _password => _passwordController.text;

  final FocusNode _passwordFocusNode = FocusNode();

  EmailSignInFormType _signInFormType = EmailSignInFormType.signIn;

  void _submit() async {
    try {
      if (_signInFormType == EmailSignInFormType.signIn) {
        await widget.auth.signInWithEmailAndPassword(_email, _password);
      } else {
        await widget.auth.createUserWithEmailAndPassword(_email, _password);
      }
      Navigator.of(context).pop();
    } catch (e) {
      print(e.toString());
    }
  }

  void _toggleFormType() {
    setState(() {
      if (_signInFormType == EmailSignInFormType.signIn) {
        _signInFormType = EmailSignInFormType.register;
      } else {
        _signInFormType = EmailSignInFormType.signIn;
      }
    });
    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChildren() {
    final buttonText =
        _signInFormType == EmailSignInFormType.signIn ? "Sign in" : "Register";
    final promptText = _signInFormType == EmailSignInFormType.signIn
        ? "Need an account? Register"
        : "Already have an account? Sign in";
    return [
      _buildEmailTextField(),
      const SizedBox(height: 8),
      _buildPasswordTextField(),
      const SizedBox(height: 16),
      FormSubmitButton(
        text: buttonText,
        callback: _submit,
      ),
      const SizedBox(height: 8),
      TextButton(
        onPressed: _toggleFormType,
        child: Text(promptText),
      ),
    ];
  }

  Widget _buildEmailTextField() {
    return TextField(
      controller: _emailController,
      decoration: const InputDecoration(
        labelText: "Email",
        hintText: "test@test.com",
      ),
      enableSuggestions: false,
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onEditingComplete: _emailEditingComplete,
    );
  }

  Widget _buildPasswordTextField() {
    return TextField(
      controller: _passwordController,
      decoration: const InputDecoration(
        labelText: "Password",
      ),
      obscureText: true,
      textInputAction: TextInputAction.done,
      focusNode: _passwordFocusNode,
      onEditingComplete: _submit,
    );
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

  void _emailEditingComplete() {
    FocusScope.of(context).requestFocus(_passwordFocusNode);
  }
}
