import 'package:bethel_smallholding/common_widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';

class FormSubmitButton extends CustomElevatedButton {
  final String text;
  final VoidCallback? callback;

  FormSubmitButton({
    Key? key,
    required this.text,
    required this.callback,
  }) : super(
          buttonColor: Colors.blue,
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            ),
          ),
          height: 44.0,
          onPressed: callback,
        );
}
