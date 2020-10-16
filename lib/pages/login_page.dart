import 'package:FireBaseDemo/blocs/authentications_bloc.dart';
import 'package:FireBaseDemo/blocs/logon_bloc.dart';
import 'package:FireBaseDemo/events/authentication_event.dart';
import 'package:FireBaseDemo/events/login_event.dart';
import 'package:FireBaseDemo/respositories/user_reposity.dart';
import 'package:FireBaseDemo/states/login_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:FireBaseDemo/pages/buttons/google_login_button.dart';
import 'package:FireBaseDemo/pages/buttons/login_button.dart';
import 'package:FireBaseDemo/pages/buttons/register_user_button.dart';
import 'package:FireBaseDemo/pages/buttons/login_button.dart';

class LoginPage extends StatefulWidget {
  final UserRepository _userRepository;
  //contructor
  LoginPage({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  LoginBloc _loginBloc;
  UserRepository get _userRepository => widget._userRepository;
  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _emailController.addListener(() {
      // when email is changed, this function is called
      _loginBloc.add(LoginEventEmailChange(email: _emailController.text));
    });
    _passwordController.addListener(() {
      // when password is changed this function is called
      _loginBloc
          .add(LoginEventPasswordChange(password: _passwordController.text));
    });
  }

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isLoginButtonEnable(LoginState loginState) =>
      loginState.isValidEmailAndPassword & isPopulated &&
      !loginState.isSubmitting;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, loginState) {
          if (loginState.isFailure) {
            print('Login failed');
          } else if (loginState.isSubmitting) {
            print('Logging in');
          } else if (loginState.isSuccess) {
            BlocProvider.of<AuthenticationBloc>(context)
                .add(AuthenticationEventLoggeddIn());
          }
          return Padding(
            padding: EdgeInsets.all(20.0),
            child: ListView(
              children: <Widget>[
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                      icon: Icon(Icons.email), labelText: 'Enter your email'),
                  keyboardType: TextInputType.emailAddress,
                  autovalidate: true,
                  autocorrect: false,
                  validator: (_) {
                    return loginState.isValidEmail
                        ? null
                        : 'Invalid email format';
                  },
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                      icon: Icon(Icons.lock), labelText: 'Enter your password'),
                  obscureText: true,
                  autovalidate: true,
                  autocorrect: false,
                  validator: (_) {
                    return loginState.isValidPassWord
                        ? null
                        : 'Invalid password format';
                  },
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      LoginButton(
                        onPressed: isLoginButtonEnable(loginState)
                            ? _onLoginEmailAndPassword
                            : null,
                      ),
                      Padding(padding: EdgeInsets.only(top: 10)),
                      GoogleLoginButton(),
                      Padding(padding: EdgeInsets.only(top: 10)),
                      RegisterUserButton(userRepository: _userRepository)
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  void _onLoginEmailAndPassword() {
    _loginBloc.add(LoginEventWithEmailAndPasswordPressed(
        email: _emailController.text, password: _passwordController.text));
  }
}
