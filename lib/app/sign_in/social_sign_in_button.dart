import 'package:flutter/material.dart';

import '../../common_widgets/custom_elevated_button.dart';

class SocialSignInButton extends CustomElevatedButton {
  SocialSignInButton({
    @required String text,
    @required VoidCallback onPressed,
    @required String assetName,
    Color color,
    Color textColor,
  })  : assert(text != null),
        assert(assetName != null),
        super(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(assetName),
              Text(
                text,
                style: TextStyle(color: textColor, fontSize: 15),
              ),
              Opacity(
                opacity: 0,
                child: Image.asset(assetName),
              ),
            ],
          ),

          onPressed: onPressed,
          color: color,
          borderRadius: 8,
          // height: 40.0,
        );
}
