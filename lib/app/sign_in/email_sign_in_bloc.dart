import 'dart:async';

import 'package:bethel_smallholding/app/sign_in/email_sign_in_model.dart';
import 'package:bethel_smallholding/services/auth.dart';

class EmailSignInBloc {
  final AuthBase auth;
  final StreamController<EmailSignInModel> _modelController =
      StreamController<EmailSignInModel>();
  Stream<EmailSignInModel> get modelStream => _modelController.stream;

  EmailSignInBloc({required this.auth});

  void dispose() {
    _modelController.close();
  }
}
