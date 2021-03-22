// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../common_widgets/show_alert_dialog.dart';
import '../services/auth.dart';

class HomePage extends StatelessWidget {
  final AuthBase auth;
  const HomePage({Key key, @required this.auth}) : super(key: key);

  Future<void> _signOut() async {
    try {
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await showAlertDialog(
      context,
      title: 'Sign out',
      content: 'Are you sure?',
      defaultActionText: 'Sign out',
      cancelActionText: 'Cancel',
    );
    if (didRequestSignOut) _signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => _confirmSignOut(context),
            child: Text(
              'Logout',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            style: TextButton.styleFrom(
              primary: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
