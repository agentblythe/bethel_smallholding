import 'dart:async';

import 'package:bethel_smallholding/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignInManager {
  final AuthBase auth;
  final ValueNotifier<bool> isLoading;

  // final StreamController<bool> _isLoadingController = StreamController<bool>();
  // Stream<bool> get isLoadingStream => _isLoadingController.stream;

  SignInManager({
    required this.auth,
    required this.isLoading,
  });

  // void dispose() {
  //   _isLoadingController.close();
  // }

  //void _setIsLoading(bool isLoading) => _isLoadingController.add(isLoading);

  Future<User?> _signIn(Future<User?> Function() signInMethod) async {
    try {
      isLoading.value = true;
      //_setIsLoading(true);
      return await signInMethod();
    } catch (e) {
      isLoading.value = false;
      //_setIsLoading(false);
      rethrow;
    }
  }

  Future<User?> signInAnonymously() async =>
      await _signIn(auth.signInAnonymously);

  Future<User?> signInWithGoogle() async =>
      await _signIn(auth.signInWithGoogle);

  Future<User?> signInWithFacebook() async =>
      await _signIn(auth.signInWithFacebook);
}
