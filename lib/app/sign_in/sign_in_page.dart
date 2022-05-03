import 'package:bethel_smallholding/app/sign_in/sign_in_button.dart';
import 'package:bethel_smallholding/app/sign_in/social_sign_in_button.dart';
import 'package:bethel_smallholding/common_widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';

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
        SocialSignInButton(
          image: "images/google-logo.png",
          text: "Sign in with Google",
          buttonColor: Colors.white,
          textColor: Colors.black87,
          onPressed: _signInWithGoogle,
        ),
        const SizedBox(
          height: 8,
        ),
        SocialSignInButton(
          image: "images/facebook-logo.png",
          text: "Sign in with Facebook",
          buttonColor: const Color(0xFF334D92),
          textColor: Colors.white,
          onPressed: _signInWithFacebook,
        ),
        const SizedBox(
          height: 8,
        ),
        SignInButton(
          text: "Sign in with Email",
          buttonColor: Colors.teal.shade700,
          textColor: Colors.white,
          onPressed: _signInWithEmail,
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

void _signInWithGoogle() {
  // TODO: Auth with Google
  print("Google");
}

void _signInWithFacebook() {
  // TODO: Auth with Facebook
  print("Facebook");
}

void _signInWithEmail() {
  // TODO: Auth with Email
  print("Email");
}

void _signInAnonymously() {
  // TODO: Anonymous
  print("Anonymous");
}
