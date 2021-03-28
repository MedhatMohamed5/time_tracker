import './validators.dart';

enum EmailSignInFormType { signIn, register }

class EmailSignInModel with EmailAndPasswordValidators {
  EmailSignInModel({
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

  final String email;
  final String password;
  final EmailSignInFormType formType;
  final bool isLoading;
  final bool isSubmitted;

  EmailSignInModel copyWith({
    email,
    password,
    formType,
    isLoading,
    isSubmitted,
  }) {
    return EmailSignInModel(
      email: email ?? this.email,
      password: password ?? this.password,
      formType: formType ?? this.formType,
      isLoading: isLoading ?? this.isLoading,
      isSubmitted: isSubmitted ?? this.isSubmitted,
    );
  }
}
