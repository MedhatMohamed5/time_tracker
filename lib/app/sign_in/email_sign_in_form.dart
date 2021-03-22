import 'package:flutter/material.dart';
import './validators.dart';
import '../../services/auth.dart';
import '../../common_widgets/form_submit_button.dart';

enum EmailSignInFormType { signIn, register }

class EmailSignInForm extends StatefulWidget with EmailAndPasswordValidators {
  EmailSignInForm({Key key, @required this.auth}) : super(key: key);

  final AuthBase auth;

  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  String get _email => emailController.text;
  String get _password => passwordController.text;
  EmailSignInFormType _formType = EmailSignInFormType.signIn;

  bool _submitted = false;

  Future<void> _submit() async {
    setState(() {
      _submitted = true;
    });
    try {
      if (_formType == EmailSignInFormType.signIn) {
        await widget.auth.signInWithEmailAndPassword(_email, _password);
      } else {
        await widget.auth.createUserWithEmailAndPassword(_email, _password);
      }
      Navigator.of(context).pop();
    } catch (e) {
      print(e.toString());
    }
  }

  _emailEditingComplete() {
    FocusScope.of(context).requestFocus(_passwordFocusNode);
  }

  void _toggleFormType() {
    setState(() {
      _formType = _formType == EmailSignInFormType.signIn
          ? EmailSignInFormType.register
          : EmailSignInFormType.signIn;
      emailController.clear();
      passwordController.clear();
    });
  }

  List<Widget> _buildChildren() {
    final primaryText = _formType == EmailSignInFormType.signIn
        ? 'Sign in'
        : 'Create an account';
    final secondaryText = _formType == EmailSignInFormType.signIn
        ? 'Need an account? Register'
        : 'Have an accoun? Sign in';

    bool enableSubmit = widget.emailValidator.isValid(_email) &&
        widget.passwordValidator.isValid(_password);
    return [
      _buildEmailTextField(),
      SizedBox(height: 8),
      _buildPasswordTextField(),
      SizedBox(
        height: 4,
      ),
      if (!_submitted)
        Text(
          'Password at least 6 letters!',
          style: TextStyle(
            fontSize: 10,
          ),
        ),
      SizedBox(height: 8),
      FormSubmitButton(
        onPressed: enableSubmit ? _submit : null,
        text: primaryText,
      ),
      SizedBox(height: 8),
      TextButton(
        child: Text(secondaryText),
        onPressed: _toggleFormType,
      ),
    ];
  }

  TextField _buildPasswordTextField() {
    var showErrorText =
        !widget.passwordValidator.isValid(_password) && _submitted;
    return TextField(
      controller: passwordController,
      focusNode: _passwordFocusNode,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        errorText: showErrorText ? widget.invalidPasswordErrorText : null,
        labelText: 'Password',
      ),
      onEditingComplete: _submit,
      obscureText: true,
      onChanged: (password) => _updateState(),
    );
  }

  TextField _buildEmailTextField() {
    var showErrorText = !widget.emailValidator.isValid(_email) && _submitted;
    return TextField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      focusNode: _emailFocusNode,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'time_tracker@email.com',
        errorText: showErrorText ? widget.invalidEmailErrorText : null,
      ),
      onEditingComplete: _emailEditingComplete,
      onChanged: (email) => _updateState(),
    );
  }

  _updateState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: _buildChildren(),
      ),
    );
  }
}
