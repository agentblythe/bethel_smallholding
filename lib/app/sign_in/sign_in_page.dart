import 'package:bethel_smallholding/app/sign_in/email_sign_in_page.dart';
import 'package:bethel_smallholding/app/sign_in/sign_in_button.dart';
import 'package:bethel_smallholding/app/sign_in/sign_in_button_with_text_and_icon.dart';
import 'package:bethel_smallholding/services/auth.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatelessWidget {
  final AuthBase auth;

  const SignInPage({
    Key? key,
    required this.auth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bethel Smallholding'),
        elevation: 2.0,
      ),
      body: _buildContent(context),
      backgroundColor: Colors.grey[200],
    );
  }

  Future<void> _signInAnonymously() async {
    try {
      await auth.signInAnonymously();
    } catch (e) {
      print("Anonymous sign-in failed with exception: ${e.toString()}");
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      await auth.signInWithGoogle();
    } catch (e) {
      print("Google sign-in failed with exception: ${e.toString()}");
    }
  }

  Future<void> _signInWithFacebook() async {
    try {
      await auth.signInWithFacebook();
    } catch (e) {
      print("Facebook sign-in failed with exception: ${e.toString()}");
    }
  }

  void _signInWithEmail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => EmailSignInPage(
          auth: auth,
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const Text(
            "Sign in",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: 48,
          ),
          SignInButtonWithTextAndIcon(
            image: "images/google-logo.png",
            text: "Sign in with Google",
            buttonColor: Colors.white,
            textColor: Colors.black87,
            onPressed: _signInWithGoogle,
          ),
          const SizedBox(
            height: 8,
          ),
          SignInButtonWithTextAndIcon(
            image: "images/facebook-logo.png",
            text: "Sign in with Facebook",
            buttonColor: const Color(0xFF334D92),
            textColor: Colors.white,
            onPressed: _signInWithFacebook,
          ),
          const SizedBox(
            height: 8,
          ),
          SignInButtonWithTextAndIcon(
            image: "images/email-icon.png",
            text: "Sign in with Email",
            buttonColor: Colors.teal.shade700,
            textColor: Colors.white,
            onPressed: () => _signInWithEmail(context),
          ),
          const SizedBox(
            height: 8,
          ),
          const Text(
            "or...",
            style: TextStyle(fontSize: 14.0, color: Colors.black),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 8,
          ),
          SignInButton(
            text: "Go Anonymous",
            buttonColor: Colors.lime.shade300,
            textColor: Colors.black,
            onPressed: _signInAnonymously,
          ),
        ],
      ),
    );
  }
}
