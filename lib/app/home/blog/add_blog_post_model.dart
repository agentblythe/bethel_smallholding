import 'package:bethel_smallholding/app/home/blog/validators.dart';
import 'package:flutter/foundation.dart';

class AddBlogPostModel with BlogPostValidators, ChangeNotifier {
  String title;
  String content;
  bool submitted;

  AddBlogPostModel({
    this.title = "",
    this.content = "",
    this.submitted = false,
  });

  String? get titleErrorText =>
      !titleValidator.isValid(title) && submitted ? titleValidator.error : null;

  String? get contentErrorText =>
      !contentValidator.isValid(content) && submitted
          ? contentValidator.error
          : null;

  void updateTitle(String title) => updateWith(title: title);

  void updateContent(String content) => updateWith(content: content);

  void submit() => updateWith(submitted: true);

  void updateWith({
    String? title,
    String? content,
    bool? submitted,
  }) {
    this.title = title ?? this.title;
    this.content = content ?? this.content;
    this.submitted = submitted ?? this.submitted;
    notifyListeners();
  }
}
