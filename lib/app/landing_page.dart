import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker/services/auth.dart';
import './sign_in/sign_in_page.dart';
import './home_page.dart';

class LandingPage extends StatefulWidget {
  final AuthBase auth;

  const LandingPage({Key key, @required this.auth}) : super(key: key);
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  User _user;
  void _updateUser(User user) {
    setState(() {
      _user = user;
    });
    print('User id : ${user?.uid}');
  }

  /*void signOut() {
    setState(() {
      _user = null;
    });
  }*/

  @override
  void initState() {
    super.initState();
    _user = widget.auth.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return _user == null
        ? SignInPage(
            onSignIn: _updateUser,
            auth: widget.auth,
          )
        : HomePage(
            onSignOut: () => _updateUser(null),
            auth: widget.auth,
          );
  }
}
