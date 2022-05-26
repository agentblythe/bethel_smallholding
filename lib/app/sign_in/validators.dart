abstract class StringValidator {
  bool isValid(String value);
}

class EmailValidator implements StringValidator {
  String error = "";

  @override
  bool isValid(String value) {
    RegExp exp = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    RegExpMatch? match = exp.firstMatch(value);

    if (match == null) {
      error = "Email is invalid";
      return false;
    }
    return true;
  }
}

class PasswordValidator implements StringValidator {
  late String error = "";

  @override
  bool isValid(String value) {
    error = "";

    // Ensure at least one lowercase letter exists.
    RegExp exp = RegExp(r".*[a-z].*");
    if (exp.firstMatch(value) == null) {
      error += "Ensure at least one lowercase letter is used\n";
    }
    // Ensure at least one uppercase letter exists
    exp = RegExp(r".*[A-Z].*");
    if (exp.firstMatch(value) == null) {
      error += "Ensure at least one uppercase letter is used\n";
    }
    // Ensure at least one digit
    exp = RegExp(r".*\d.*");
    if (exp.firstMatch(value) == null) {
      error += "Ensure at least one number is used\n";
    }
    // Ensure at least one symbol
    exp = RegExp(r".*\W.*");
    if (exp.firstMatch(value) == null) {
      error += "Ensure at least one symbol is used\n";
    }
    // Ensure at least 8 characters
    if (value.length < 8) {
      error += "Ensure at least 8 characters long\n";
    }

    if (error == "") {
      return true;
    } else {
      return false;
    }
  }
}

class EmailAndPasswordValidators {
  final EmailValidator emailValidator = EmailValidator();
  final PasswordValidator passwordValidator = PasswordValidator();
}
