import 'package:flutter/material.dart';

import '../../common_widgets/custom_elevated_button.dart';

class SignInButton extends CustomElevatedButton {
  SignInButton({
    @required String text,
    @required VoidCallback onPressed,
    Color color,
    Color textColor,
  })  : assert(text != null),
        super(
          child: Text(
            text,
            style: TextStyle(color: textColor, fontSize: 15),
          ),
          onPressed: onPressed,
          color: color,
          borderRadius: 8,
          // height: 40.0,
        );
}
