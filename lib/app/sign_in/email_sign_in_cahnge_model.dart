import 'package:flutter/foundation.dart';
import 'package:time_tracker/services/auth.dart';

import './email_sign_in_model.dart';

import './validators.dart';

class EmailSignInChangeModel with EmailAndPasswordValidators, ChangeNotifier {
  EmailSignInChangeModel({
    @required this.auth,
    this.email = '',
    this.password = ' ',
    this.formType = EmailSignInFormType.signIn,
    this.isLoading = false,
    this.isSubmitted = false,
  });

  String get primaryButtonText =>
      formType == EmailSignInFormType.signIn ? 'Sign in' : 'Create an account';

  String get secondaryButtonText => formType == EmailSignInFormType.signIn
      ? 'Need an account? Register'
      : 'Have an accoun? Sign in';

  bool get canSubmit =>
      emailValidator.isValid(email) &&
      passwordValidator.isValid(password) &&
      !isLoading;

  String get passwordErrorText {
    bool showErrorText = !passwordValidator.isValid(password) && isSubmitted;
    return showErrorText ? invalidPasswordErrorText : null;
  }

  String get emailErrorText {
    bool showErrorText = !emailValidator.isValid(email) && isSubmitted;
    return showErrorText ? invalidEmailErrorText : null;
  }

  final AuthBase auth;
  String email;
  String password;
  EmailSignInFormType formType;
  bool isLoading;
  bool isSubmitted;

  void updateWith({
    email,
    password,
    formType,
    isLoading,
    isSubmitted,
  }) {
    this.email = email ?? this.email;
    this.password = password ?? this.password;
    this.formType = formType ?? this.formType;
    this.isLoading = isLoading ?? this.isLoading;
    this.isSubmitted = isSubmitted ?? this.isSubmitted;
    notifyListeners();
  }

  void toogleFormType() {
    var formType = this.formType == EmailSignInFormType.signIn
        ? EmailSignInFormType.register
        : EmailSignInFormType.signIn;
    updateWith(
      isSubmitted: false,
      isLoading: false,
      email: '',
      password: '',
      formType: formType,
    );
  }

  void updateEmail(String email) => updateWith(email: email);

  void updatePassword(String password) => updateWith(password: password);

  Future<void> submit() async {
    updateWith(isLoading: true, isSubmitted: true);
    try {
      if (this.formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(email, password);
      } else {
        await auth.createUserWithEmailAndPassword(email, password);
      }
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }
}
