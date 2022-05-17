import 'package:bethel_smallholding/common_widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';

class FormSubmitButton extends CustomElevatedButton {
  final Widget child;
  final VoidCallback? callback;

  FormSubmitButton({
    Key? key,
    required this.child,
    required this.callback,
  }) : super(
          buttonColor: Colors.blue,
          child: child,
          height: 44.0,
          onPressed: callback,
        );
}
