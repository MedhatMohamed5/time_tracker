// import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './sign_in_bloc.dart';
import '../../common_widgets/show_exception_alert_dialog.dart';

import '../../services/auth.dart';

import './sign_in_button.dart';
import './email_sign_in_page.dart';
import './social_sign_in_button.dart';

class SignInPage extends StatefulWidget {
  static Widget create(BuildContext context) {
    return Provider<SignInBloc>(
      create: (_) => SignInBloc(),
      child: SignInPage(),
    );
  }

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  // bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<SignInBloc>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: Text('Time Tracker'),
        centerTitle: true,
      ),
      body: StreamBuilder<bool>(
          stream: bloc.isLoadingStream,
          initialData: false,
          builder: (context, snapshot) {
            return _buildContent(context, snapshot.data);
          }),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContent(BuildContext context, bool isLoading) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            child: _buildHeader(isLoading),
            height: 50,
          ),
          SizedBox(height: 48),
          SocialSignInButton(
            assetName: 'images/google-logo.png',
            onPressed: isLoading ? null : () => _signInWithGoogle(context),
            text: 'Sign in with Google',
            textColor: Colors.black87,
            color: Colors.white,
          ),
          SizedBox(
            height: 8,
          ),
          SocialSignInButton(
            assetName: 'images/facebook-logo.png',
            text: 'Sign in with Facebook',
            textColor: Colors.white,
            color: Color(0xFF334D92), //Colors.blue,
            onPressed: isLoading ? null : () => _signInWithFacebook(context),
          ),
          SizedBox(
            height: 8,
          ),
          SignInButton(
            text: 'Sign in with Email',
            textColor: Colors.white,
            color: Colors.teal.shade700, //Colors.blue,
            onPressed: isLoading ? null : () => _signInWithEmail(context),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            'or',
            style: TextStyle(
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 8,
          ),
          SignInButton(
            text: 'Go Anonymous',
            textColor: Colors.black87,
            color: Colors.lime.shade300, //Colors.blue,
            onPressed: isLoading ? null : () => _signInAnonymously(context),
          ),
        ],
      ),
    );
  }

  void _signInWithEmail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => EmailSignInPage(),
      ),
    );
  }

  void _updateLoadingState(bool value) {
    final bloc = Provider.of<SignInBloc>(context, listen: false);
    bloc.setIsLoading(value);
  }

  void _showSignInError(BuildContext context, Exception exception) {
    if (exception is FirebaseException &&
        exception.code != 'ERROR_ABORTED_BY_USER')
      showExceptionAlertDialog(
        context,
        title: 'Sign in failed',
        exception: exception,
      );
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    _updateLoadingState(true);
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);

      await auth.signInWithGoogle();
    } catch (e) {
      print(e.toString());
      _showSignInError(context, e);
    } finally {
      _updateLoadingState(false);
    }
  }

  Future<void> _signInWithFacebook(BuildContext context) async {
    _updateLoadingState(true);
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);

      await auth.signInWithFacebook();
    } catch (e) {
      _showSignInError(context, e);
      print(e.toString());
    } finally {
      _updateLoadingState(false);
    }
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    _updateLoadingState(true);
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);

      await auth.signInAnonymously();
    } catch (e) {
      _showSignInError(context, e);
      print(e.toString());
    } finally {
      _updateLoadingState(false);
    }
  }

  Widget _buildHeader(bool isLoading) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Text(
            'Sign in',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w600,
            ),
          );
  }
}
