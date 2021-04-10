import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'email_sign_in_bloc.dart';
import '../../common_widgets/show_exception_alert_dialog.dart';
// import 'validators.dart';
import '../../services/auth.dart';
import '../../common_widgets/form_submit_button.dart';
import './email_sign_in_cahnge_model.dart';
// import 'email_sign_in_model.dart';

class EmailSignInFormChangeNotifier extends StatefulWidget {
  EmailSignInFormChangeNotifier({Key key, @required this.model})
      : super(key: key);

  final EmailSignInChangeModel model;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<EmailSignInChangeModel>(
        create: (_) => EmailSignInChangeModel(auth: auth),
        child: Consumer<EmailSignInChangeModel>(
          builder: (_, model, __) =>
              EmailSignInFormChangeNotifier(model: model),
        ));
  }

  @override
  _EmailSignInFormChangeNotifierState createState() =>
      _EmailSignInFormChangeNotifierState();
}

class _EmailSignInFormChangeNotifierState
    extends State<EmailSignInFormChangeNotifier> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  Future<void> _submit() async {
    try {
      await widget.model.submit();
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      showExceptionAlertDialog(context, title: 'Sign in failed', exception: e);
    }
  }

  EmailSignInChangeModel get model => widget.model;

  _emailEditingComplete() {
    final newFocus = model.emailValidator.isValid(model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _toggleFormType() {
    widget.model.toogleFormType();
    emailController.clear();
    passwordController.clear();
  }

  List<Widget> _buildChildren() {
    return [
      _buildEmailTextField(),
      SizedBox(height: 8),
      _buildPasswordTextField(),
      SizedBox(
        height: 4,
      ),
      if (!model.isSubmitted)
        Text(
          'Password at least 6 letters!',
          style: TextStyle(
            fontSize: 10,
          ),
        ),
      SizedBox(height: 8),
      !model.isLoading
          ? FormSubmitButton(
              onPressed: model.canSubmit ? _submit : null,
              text: model.primaryButtonText,
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
      SizedBox(height: 8),
      TextButton(
        child: Text(model.secondaryButtonText),
        onPressed: !model.isLoading ? _toggleFormType : null,
      ),
    ];
  }

  TextField _buildPasswordTextField() {
    /*var showErrorText =
        !model.passwordValidator.isValid(model.password) && model.isSubmitted;*/
    return TextField(
      enabled: !model.isLoading,
      controller: passwordController,
      focusNode: _passwordFocusNode,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        errorText: model.passwordErrorText,
        /*showErrorText ? model.invalidPasswordErrorText : null,*/
        labelText: 'Password',
      ),
      onEditingComplete: _submit,
      obscureText: true,
      onChanged: model.updatePassword,
    );
  }

  TextField _buildEmailTextField() {
    /*var showErrorText =
        !model.emailValidator.isValid(model.email) && model.isSubmitted;*/
    return TextField(
      enabled: !model.isLoading,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      focusNode: _emailFocusNode,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'time_tracker@email.com',
        errorText: model
            .emailErrorText, //showErrorText ? model.invalidEmailErrorText : null,
      ),
      onEditingComplete: () => _emailEditingComplete(),
      onChanged: model.updateEmail,
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
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
