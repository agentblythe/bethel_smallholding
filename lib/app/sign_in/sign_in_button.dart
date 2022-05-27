import 'package:bethel_smallholding/common_widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';

class SignInButton extends CustomElevatedButton {
  SignInButton({
    Key? key,
    required final String text,
    required final Color buttonColor,
    final Color? textColor,
    final VoidCallback? onPressed,
  }) : super(
          key: key,
          child: Text(
            text,
            style: TextStyle(
              color: textColor ?? Colors.white,
              fontSize: 15.0,
            ),
          ),
          buttonColor: buttonColor,
          onPressed: onPressed,
        );
}
