import 'package:bethel_smallholding/app/home/blog/validators.dart';
import 'package:flutter/foundation.dart';

class AddBlogPostModel with BlogPostValidators, ChangeNotifier {
  String title;
  String content;

  bool submittedTapped;
  bool submitting;
  bool titleNextPressed;
  bool contentDonePressed;

  AddBlogPostModel({
    this.title = "",
    this.content = "",
    this.submittedTapped = false,
    this.submitting = false,
    this.titleNextPressed = false,
    this.contentDonePressed = false,
  });

  String? get titleErrorText =>
      !titleValidator.isValid(title) && (submittedTapped || titleNextPressed)
          ? titleValidator.error
          : null;

  String? get contentErrorText => !contentValidator.isValid(content) &&
          (submittedTapped || contentDonePressed)
      ? contentValidator.error
      : null;

  bool get submitEnabled =>
      titleValidator.isValid(title) &&
      contentValidator.isValid(content) &&
      !submitting;

  void updateTitle(String title) => updateWith(title: title);

  void updateContent(String content) => updateWith(content: content);

  void titleNextTapped() => updateWith(titleNextPressed: true);

  void contentDoneTapped() => updateWith(contentDonePressed: true);

  void updateWith({
    String? title,
    String? content,
    bool? submittedTapped,
    bool? submitting,
    bool? titleNextPressed,
    bool? contentDonePressed,
  }) {
    this.title = title ?? this.title;
    this.content = content ?? this.content;
    this.submittedTapped = submittedTapped ?? this.submittedTapped;
    this.submitting = submitting ?? this.submitting;
    this.titleNextPressed = titleNextPressed ?? this.titleNextPressed;
    this.contentDonePressed = contentDonePressed ?? this.contentDonePressed;
    notifyListeners();
  }
}
