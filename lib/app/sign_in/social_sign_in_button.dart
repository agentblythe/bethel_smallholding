import 'dart:ui';

import 'package:bethel_smallholding/common_widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class SocialSignInButton extends CustomElevatedButton {
  SocialSignInButton({
    required String image,
    required String text,
    required Color color,
    required Color textColor,
    required VoidCallback onPressed,
  }) : super(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(image),
              Text(
                text,
                style: TextStyle(color: textColor, fontSize: 15.0),
              ),
              Opacity(
                opacity: 0.0,
                child: Image.asset(image),
              )
            ],
          ),
          color: color,
          onPressed: onPressed,
        );
}
