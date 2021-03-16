import 'package:flutter/material.dart';
import '../../common_widgets/form_submit_button.dart';

enum EmailSignInFormType { signIn, register }

class EmailSignInForm extends StatefulWidget {
  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  EmailSignInFormType _formType = EmailSignInFormType.signIn;

  void _submit() {
    print(emailController.text);
    print(passwordController.text);
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

    return [
      TextField(
        controller: emailController,
        decoration: InputDecoration(
          labelText: 'Email',
          hintText: 'time_tracker@email.com',
        ),
      ),
      SizedBox(height: 8),
      TextField(
        controller: passwordController,
        decoration: InputDecoration(
          labelText: 'Password',
        ),
        obscureText: true,
      ),
      SizedBox(height: 8),
      FormSubmitButton(
        onPressed: _submit,
        text: primaryText,
      ),
      SizedBox(height: 8),
      TextButton(
        child: Text(secondaryText),
        onPressed: _toggleFormType,
      ),
    ];
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
