// do the same as "Login Event"
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

//defind Bloc
abstract class RegisterEvent extends Equatable {
  const RegisterEvent();
  @override
  List<Object> get props => [];
}

class RegisterEventEmailChange extends RegisterEvent {
  final String email;
  const RegisterEventEmailChange({@required this.email});
  @override
  List<Object> get props => [email];
  @override
  String toString() => 'RegisterEventEmailChange: $email';
}

class RegisterEventPasswordChange extends RegisterEvent {
  final String password;
  const RegisterEventPasswordChange({@required this.password});
  @override
  List<Object> get props => [password];
  @override
  String toString() => 'RegisterEventPasswordChange: $password';
}

class RegisterEventPressed extends RegisterEvent {
  final String email;
  final String password;

  const RegisterEventPressed({
    @required this.email,
    @required this.password,
  });
  @override
  List<Object> get props => [email, password];
  @override
  String toString() {
    return 'RegisterEventPressed, email:$email,password:$password';
  }
}
