abstract class StringValidator {
  bool isValid(String value);
}

class EmailValidator implements StringValidator {
  String get error => _error;

  String _error = "";

  @override
  bool isValid(String value) {
    RegExp exp = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    RegExpMatch? match = exp.firstMatch(value);

    if (match == null) {
      _error = "Email is invalid";
      return false;
    }
    return true;
  }
}

class PasswordValidator implements StringValidator {
  String get error => _error;

  String _error = "";

  @override
  bool isValid(String value) {
    // Ensure at least one lowercase letter exists.
    RegExp exp = RegExp(r".*[a-z].*");
    if (exp.firstMatch(value) == null) {
      _error += "Ensure at least one lowercase letter is used\n";
    }
    // Ensure at least one uppercase letter exists
    exp = RegExp(r".*[A-Z].*");
    if (exp.firstMatch(value) == null) {
      _error += "Ensure at least one uppercase letter is used\n";
    }
    // Ensure at least one digit
    exp = RegExp(r".*\d.*");
    if (exp.firstMatch(value) == null) {
      _error += "Ensure at least one number is used\n";
    }
    // Ensure at least one symbol
    exp = RegExp(r".*\W.*");
    if (exp.firstMatch(value) == null) {
      _error += "Ensure at least one symbol is used\n";
    }
    // Ensure at least 8 characters
    if (value.length < 8) {
      _error += "Ensure at least 8 characters long\n";
    }

    return _error == "";
  }
}

class EmailAndPasswordValidators {
  final EmailValidator emailValidator = EmailValidator();
  final PasswordValidator passwordValidator = PasswordValidator();
}
