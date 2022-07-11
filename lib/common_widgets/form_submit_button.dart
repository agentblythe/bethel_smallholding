import 'package:bethel_smallholding/common_widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';

class FormSubmitButton extends CustomElevatedButton {
  final Widget newChild;
  final VoidCallback? callback;

  const FormSubmitButton({
    Key? key,
    required this.newChild,
    required this.callback,
  }) : super(
          key: key,
          buttonColor: Colors.blue,
          child: newChild,
          height: 44.0,
          onPressed: callback,
        );
}
