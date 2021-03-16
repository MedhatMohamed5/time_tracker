import 'package:flutter/material.dart';

import './custom_elevated_button.dart';

class FormSubmitButton extends CustomElevatedButton {
  FormSubmitButton({
    @required String text,
    @required VoidCallback onPressed,
  }) : super(
          child: Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 20.0),
          ),
          onPressed: onPressed,
          height: 44.0,
          borderRadius: 4.0,
          color: Colors.indigo,
        );
}
