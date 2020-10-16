import 'package:meta/meta.dart';

@immutable // noi tai ben trong cai state k thay doi
class LoginState {
  final bool isValidEmail;
  final bool isValidPassWord;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;
  bool get isValidEmailAndPassword => isValidEmail && isValidPassWord;
  //contructor
  LoginState({
    @required this.isValidEmail,
    @required this.isValidPassWord,
    @required this.isSubmitting,
    @required this.isSuccess,
    @required this.isFailure,
  });
  // each state is an object, or satic object
  // can be create by using static/factory method
  //state begin
  factory LoginState.initial() {
    return LoginState(
        isValidEmail: true,
        isValidPassWord: true,
        isSubmitting: false,
        isSuccess: false,
        isFailure: false);
  }
  //loading state?
  factory LoginState.loading() {
    return LoginState(
        isValidEmail: true,
        isValidPassWord: true,
        isSubmitting: true,
        isSuccess: false,
        isFailure: false);
  }
  //Failure state?
  factory LoginState.failure() {
    return LoginState(
        isValidEmail: true,
        isValidPassWord: true,
        isSubmitting: false,
        isSuccess: false,
        isFailure: true);
  }
  //Success state?
  factory LoginState.success() {
    return LoginState(
        isValidEmail: true,
        isValidPassWord: true,
        isSubmitting: false,
        isSuccess: true,
        isFailure: false);
  }
  //Clone an object of LoginState
  LoginState cloneWith({
    final bool isValidEmail,
    final bool isValidPassWord,
    final bool isSubmitting,
    final bool isSuccess,
    final bool isFailure,
  }) {
    return LoginState(
        isValidEmail: isValidEmail ?? this.isValidEmail,
        isValidPassWord: isValidPassWord ?? this.isValidPassWord,
        isSubmitting: isSubmitting ?? this.isSubmitting,
        isSuccess: isSuccess ?? this.isSuccess,
        isFailure: isFailure ?? this.isFailure);
  }

  //How to clone an object and update that object?
  LoginState cloneAndUpdate({bool isValidEmail, bool isValidPassword}) {
    return cloneWith(
        isValidEmail: isValidEmail,
        isValidPassWord: isValidPassword,
        isFailure: false,
        isSubmitting: false,
        isSuccess: false);
  }
}
