import 'package:bethel_smallholding/app/sign_in/validators.dart';
import 'package:bethel_smallholding/services/auth.dart';
import 'package:flutter/foundation.dart';
import 'email_sign_in_model.dart';

class EmailSignInChangeModel with EmailAndPasswordValidators, ChangeNotifier {
  final AuthBase auth;
  String email;
  String password;
  EmailSignInFormType formType;
  bool isLoading;
  bool submitted;
  bool hidePassword;

  EmailSignInChangeModel({
    required this.auth,
    this.email = "",
    this.password = "",
    this.formType = EmailSignInFormType.signIn,
    this.isLoading = false,
    this.submitted = false,
    this.hidePassword = true,
  });

  String get primaryButtonText =>
      formType == EmailSignInFormType.signIn ? "Sign in" : "Register";

  String get secondaryButtonText => formType == EmailSignInFormType.signIn
      ? "Need an account? Register"
      : "Already have an account? Sign in";

  bool get submitEnabled =>
      emailValidator.isValid(email) &&
      passwordValidator.isValid(password) &&
      !isLoading;

  bool get restPasswordEnabled => emailValidator.isValid(email) && !isLoading;

  String? get emailErrorText =>
      !emailValidator.isValid(email) && submitted ? emailValidator.error : null;

  String? get passwordErrorText {
    if (!passwordValidator.isValid(password)) {
      if (formType == EmailSignInFormType.signIn) {
        if (submitted) {
          return passwordValidator.error;
        }
      } else {
        return passwordValidator.error;
      }
    }
    return null;
  }

  void toggleFormType() {
    updateWith(
      email: "",
      password: "",
      formType: formType == EmailSignInFormType.signIn
          ? EmailSignInFormType.register
          : EmailSignInFormType.signIn,
      isLoading: false,
      submitted: false,
      hidePassword: true,
    );
  }

  void togglePasswordVisibility() {
    updateWith(hidePassword: !hidePassword);
  }

  void updateEmail(String email) => updateWith(email: email);

  void updatePassword(String password) => updateWith(password: password);

  Future<void> submit() async {
    updateWith(submitted: true, isLoading: true);

    try {
      if (formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(email, password);
      } else {
        await auth.createUserWithEmailAndPassword(email, password);
      }
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

  void updateWith({
    String? email,
    String? password,
    EmailSignInFormType? formType,
    bool? isLoading,
    bool? submitted,
    bool? hidePassword,
  }) {
    this.email = email ?? this.email;
    this.password = password ?? this.password;
    this.formType = formType ?? this.formType;
    this.isLoading = isLoading ?? this.isLoading;
    this.submitted = submitted ?? this.submitted;
    this.hidePassword = hidePassword ?? this.hidePassword;
    notifyListeners();
  }
}
