import 'package:bethel_smallholding/services/auth.dart';
import 'package:flutter/material.dart';

class AuthProvider extends InheritedWidget {
  final AuthBase auth;
  final Widget child;

  const AuthProvider({
    required this.auth,
    required this.child,
  }) : super(child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }

  static AuthBase? of(BuildContext context) {
    AuthProvider? provider =
        context.dependOnInheritedWidgetOfExactType<AuthProvider>();
    return provider?.auth;
  }
}
