import 'package:bethel_smallholding/app/home_page.dart';
import 'package:bethel_smallholding/app/sign_in/sign_in_page.dart';
import 'package:bethel_smallholding/services/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = AuthProvider.of(context);
    if (auth == null) {
      throw Exception("Unable to locate AuthProvider in the Widget Tree");
    }

    return StreamBuilder<User?>(
      stream: auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          if (user == null) {
            return SignInPage();
          }
          return HomePage();
        }
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
