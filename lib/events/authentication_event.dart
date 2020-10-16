import 'package:equatable/equatable.dart';

abstract class AuthenticationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthenticationEventStarted extends AuthenticationEvent {}

class AuthenticationEventLoggeddIn extends AuthenticationEvent {}

class AuthenticationEventLoggedOut extends AuthenticationEvent {}
