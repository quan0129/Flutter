import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
  @override
  List<Object> get props => [];
}

class LoginEventEmailChange extends LoginEvent {
  final String email;
  //contructor
  const LoginEventEmailChange({this.email});
  @override
  List<Object> get props => [email];
  @override
  String toString() => 'Email change: $email';
}

class LoginEventPasswordChange extends LoginEvent {
  final String password;
  const LoginEventPasswordChange({this.password});
  @override
  List<Object> get props => [password];
  @override
  String toString() => 'Password changed: $password';
}

class LoginEventWithGooglePressed extends LoginEvent {}

class LoginEventWithEmailAndPasswordPressed extends LoginEvent {
  final String email;
  final String password;
  const LoginEventWithEmailAndPasswordPressed(
      {@required this.email, @required this.password});
  @override
  List<Object> get props => [email, password];
  @override
  String toString() =>
      'Login Event with Email and Password Pressed, email=$email, password=$password';
}
