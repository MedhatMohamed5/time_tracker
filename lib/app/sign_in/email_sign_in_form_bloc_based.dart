import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './email_sign_in_bloc.dart';
import '../../common_widgets/show_exception_alert_dialog.dart';
// import 'validators.dart';
import '../../services/auth.dart';
import '../../common_widgets/form_submit_button.dart';
import 'email_sign_in_model.dart';

class EmailSignInFormBlocBased extends StatefulWidget {
  EmailSignInFormBlocBased({Key key, @required this.bloc}) : super(key: key);

  final EmailSignInBloc bloc;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return Provider<EmailSignInBloc>(
      create: (_) => EmailSignInBloc(auth),
      child: Consumer<EmailSignInBloc>(
        builder: (_, bloc, __) => EmailSignInFormBlocBased(bloc: bloc),
      ),
      dispose: (_, bloc) => bloc.dispose(),
    );
  }

  @override
  _EmailSignInFormBlocBasedState createState() =>
      _EmailSignInFormBlocBasedState();
}

class _EmailSignInFormBlocBasedState extends State<EmailSignInFormBlocBased> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  Future<void> _submit() async {
    try {
      await widget.bloc.submit();
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      showExceptionAlertDialog(context, title: 'Sign in failed', exception: e);
    }
  }

  _emailEditingComplete(EmailSignInModel model) {
    final newFocus = model.emailValidator.isValid(model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _toggleFormType() {
    widget.bloc.toogleFormType();
    emailController.clear();
    passwordController.clear();
  }

  List<Widget> _buildChildren(EmailSignInModel model) {
    return [
      _buildEmailTextField(model),
      SizedBox(height: 8),
      _buildPasswordTextField(model),
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

  TextField _buildPasswordTextField(EmailSignInModel model) {
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
      onChanged: widget.bloc.updatePassword,
    );
  }

  TextField _buildEmailTextField(EmailSignInModel model) {
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
      onEditingComplete: () => _emailEditingComplete(model),
      onChanged: widget.bloc.updateEmail,
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
    return StreamBuilder<EmailSignInModel>(
      stream: widget.bloc.modelStream,
      initialData: EmailSignInModel(),
      builder: (context, snapshot) {
        EmailSignInModel model = snapshot.data;
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: _buildChildren(model),
          ),
        );
      },
    );
  }
}
