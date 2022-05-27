import 'package:bethel_smallholding/common_widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';

class SignInButtonWithTextAndIcon extends CustomElevatedButton {
  SignInButtonWithTextAndIcon({
    Key? key,
    required final String image,
    required final String text,
    required final Color buttonColor,
    final Color? textColor,
    final VoidCallback? onPressed,
  }) : super(
          key: key,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(image),
              Text(
                text,
                style: TextStyle(
                  color: textColor ?? Colors.white,
                  fontSize: 15.0,
                ),
              ),
              Opacity(
                opacity: 0.0,
                child: Image.asset(image),
              )
            ],
          ),
          buttonColor: buttonColor,
          onPressed: onPressed,
        );
}
