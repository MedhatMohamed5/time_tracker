import 'dart:async';

class SignInBloc {
  final StreamController<bool> _isLoadingController = StreamController<bool>();
  Stream<bool> get isLoadingStream => _isLoadingController.stream;

  dispose() {
    _isLoadingController.close();
  }

  void setIsLoading(bool isLoading) => _isLoadingController.add(isLoading);
}
