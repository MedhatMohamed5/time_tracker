abstract class StringValidator {
  bool isValid(String value);
}

class NonEmptyStringValidator implements StringValidator {
  @override
  bool isValid(String value) {
    return value.isNotEmpty;
  }
}

class NotValidPasswordValidator implements StringValidator {
  @override
  bool isValid(String value) {
    return value.length >= 6;
  }
}

class EmailAndPasswordValidators {
  final StringValidator emailValidator = NonEmptyStringValidator();
  final StringValidator passwordValidator = NotValidPasswordValidator();
  final String invalidPasswordErrorText =
      'Password cannot be less than 6 letters!';
  final String invalidEmailErrorText = 'Email cannot be empty!';
}
