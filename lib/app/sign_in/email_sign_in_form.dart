import 'dart:io';

import 'package:bethel_smallholding/app/sign_in/validators.dart';
import 'package:bethel_smallholding/common_widgets/form_submit_button.dart';
import 'package:bethel_smallholding/common_widgets/show_alert_dialog.dart';
import 'package:bethel_smallholding/common_widgets/show_exception_alert_dialog.dart';
import 'package:bethel_smallholding/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum EmailSignInFormType {
  signIn,
  register,
}

class EmailSignInForm extends StatefulWidget with EmailAndPasswordvalidators {
  EmailSignInForm({
    Key? key,
  }) : super(key: key);

  @override
  State<EmailSignInForm> createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String get _email => _emailController.text;
  String get _password => _passwordController.text;

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  EmailSignInFormType _signInFormType = EmailSignInFormType.signIn;

  bool _submitted = false;
  bool _isLoading = false;

  void _submit() async {
    setState(() {
      _submitted = true;
      _isLoading = true;
    });

    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      if (_signInFormType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(_email, _password);
      } else {
        await auth.createUserWithEmailAndPassword(_email, _password);
      }
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      showExceptionAlertDialog(
        context,
        title: "Sign in failed",
        exception: e,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _toggleFormType() {
    setState(() {
      _submitted = false;
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
    bool _submitEnabled = widget.emailValidator.isValid(_email) &&
        widget.passwordValidator.isValid(_password) &&
        !_isLoading;

    return [
      _buildEmailTextField(),
      const SizedBox(height: 8),
      _buildPasswordTextField(),
      const SizedBox(height: 16),
      FormSubmitButton(
        child: !_isLoading
            ? Text(
                buttonText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              )
            : const CircularProgressIndicator(),
        callback: _submitEnabled ? _submit : null,
      ),
      const SizedBox(height: 8),
      TextButton(
        onPressed: !_isLoading ? _toggleFormType : null,
        child: Text(promptText),
      ),
    ];
  }

  Widget _buildEmailTextField() {
    bool showEmailErrorText =
        !widget.emailValidator.isValid(_email) && _submitted;
    return TextField(
      controller: _emailController,
      decoration: InputDecoration(
        labelText: "Email",
        hintText: "test@test.com",
        errorText: showEmailErrorText ? widget.invalidEmailErrorText : null,
        enabled: !_isLoading,
      ),
      enableSuggestions: false,
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      focusNode: _emailFocusNode,
      onEditingComplete: _emailEditingComplete,
      onChanged: (email) => _updateState(),
    );
  }

  Widget _buildPasswordTextField() {
    bool showPasswordErrorText =
        !widget.passwordValidator.isValid(_password) && _submitted;
    return TextField(
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: "Password",
        errorText:
            showPasswordErrorText ? widget.invalidPasswordErrorText : null,
        enabled: !_isLoading,
      ),
      obscureText: true,
      textInputAction: TextInputAction.done,
      focusNode: _passwordFocusNode,
      onEditingComplete: _submit,
      onChanged: (email) => _updateState(),
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
    final newFocus = widget.emailValidator.isValid(_email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _updateState() {
    setState(() {});
  }
}
