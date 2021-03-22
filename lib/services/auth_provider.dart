import 'package:flutter/material.dart';
import './auth.dart';

class AuthProvider extends InheritedWidget {
  final AuthBase authBase;
  final Widget child;

  AuthProvider({@required this.authBase, @required this.child});

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;

  static AuthBase of(BuildContext context) {
    AuthProvider provider =
        context.dependOnInheritedWidgetOfExactType<AuthProvider>();
    return provider.authBase;
  }
}
