import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final Widget child;
  final Color color;
  final double borderRadius;
  final VoidCallback onPressed;
  final double height;
  CustomElevatedButton({
    @required this.child,
    @required this.onPressed,
    this.color,
    this.borderRadius: 2,
    this.height: 50,
  }) : assert(borderRadius != null);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ElevatedButton(
        child: child,
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          primary: color ?? Colors.white,
          onPrimary: Colors.black87,
          onSurface: color ?? Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 8.0),
          ),
        ),
      ),
    );
  }
}
