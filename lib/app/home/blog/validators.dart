import 'package:bethel_smallholding/app/utilities/validators.dart';

class BlogPostValidators {
  final TitleValidator titleValidator = TitleValidator();
  final ContentValidator contentValidator = ContentValidator();
}

class TitleValidator implements StringValidator {
  String get error => _error;

  String _error = "";

  @override
  bool isValid(String? value) {
    if (value == null || value.trim().isEmpty) {
      _error = "Title cannot be empty";
      return false;
    }
    return true;
  }
}

class ContentValidator implements StringValidator {
  String get error => _error;

  String _error = "";

  @override
  bool isValid(String? value) {
    if (value == null || value.trim().isEmpty) {
      _error = "Content cannot be empty";
      return false;
    }
    return true;
  }
}
