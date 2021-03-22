import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/auth.dart';
import './sign_in/sign_in_page.dart';
import './home_page.dart';

class LandingPage extends StatelessWidget {
  final AuthBase auth;

  const LandingPage({Key key, @required this.auth}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;

          return user == null
              ? SignInPage(
                  auth: auth,
                )
              : HomePage(
                  auth: auth,
                );
        }

        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
