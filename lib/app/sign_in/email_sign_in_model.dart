import 'package:bethel_smallholding/app/sign_in/validators.dart';

enum EmailSignInFormType {
  signIn,
  register,
}

class EmailSignInModel with EmailAndPasswordValidators {
  final String email;
  final String password;
  final EmailSignInFormType formType;
  final bool isLoading;
  final bool submitted;

  EmailSignInModel({
    this.email = "",
    this.password = "",
    this.formType = EmailSignInFormType.signIn,
    this.isLoading = false,
    this.submitted = false,
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

  EmailSignInModel CopyWith({
    String? email,
    String? password,
    EmailSignInFormType? formType,
    bool? isLoading,
    bool? submitted,
  }) {
    return EmailSignInModel(
      email: email ?? this.email,
      password: password ?? this.password,
      formType: formType ?? this.formType,
      isLoading: isLoading ?? this.isLoading,
      submitted: submitted ?? this.submitted,
    );
  }
}
