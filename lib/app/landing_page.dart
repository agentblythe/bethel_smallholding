import 'package:bethel_smallholding/app/home_page.dart';
import 'package:bethel_smallholding/app/sign_in/sign_in_page.dart';
import 'package:bethel_smallholding/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatefulWidget {
  final AuthBase auth;
  const LandingPage({
    Key? key,
    required this.auth,
  }) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  User? _user;

  @override
  void initState() {
    super.initState();
    _updateUser(widget.auth.currentUser);
  }

  void _updateUser(User? user) {
    setState(() {
      _user = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: widget.auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          if (user == null) {
            return SignInPage(
              onSignIn: _updateUser,
              auth: widget.auth,
            );
          }
          return HomePage(
            onSignOut: () => _updateUser(null),
            auth: widget.auth,
          );
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
