import 'package:FireBaseDemo/blocs/authentications_bloc.dart';
import 'package:FireBaseDemo/blocs/register_bloc.dart';
import 'package:FireBaseDemo/events/authentication_event.dart';
import 'package:FireBaseDemo/events/register_event.dart';
import 'package:FireBaseDemo/pages/buttons/register_button.dart';
import 'package:FireBaseDemo/respositories/user_reposity.dart';
import 'package:FireBaseDemo/states/register_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterPage extends StatefulWidget {
  final UserRepository _userRepository;
  RegisterPage({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);
  @override
  State<RegisterPage> createState() {
    return _RegisterPage();
  }
}

class _RegisterPage extends State<RegisterPage> {
  UserRepository get _userRepository => widget._userRepository;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  RegisterBloc _registerBloc;

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isRegisterButtonEnable(RegisterState state) {
    return state.isValidEmailAndPassword && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _registerBloc = BlocProvider.of<RegisterBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Center(
        child: BlocProvider<RegisterBloc>(
          create: (context) => RegisterBloc(userRepository: _userRepository),
          child: BlocBuilder<RegisterBloc, RegisterState>(
              builder: (context, registerState) {
            if (registerState.isFailure) {
              print('Register Failed');
            } else if (registerState.isSubmitting) {
              print('Register in progress...');
            } else if (registerState.isSuccess) {
              BlocProvider.of<AuthenticationBloc>(context)
                  .add(AuthenticationEventLoggeddIn());
            }
            return Padding(
              padding: EdgeInsets.all(20),
              child: Form(
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                          icon: Icon(Icons.email), labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      autovalidate: true,
                      validator: (_) {
                        return !registerState.isValidPassword
                            ? 'Invalid password'
                            : null;
                      },
                    ),
                    TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          icon: Icon(Icons.lock),
                          labelText: 'Password',
                        ),
                        obscureText: true,
                        autocorrect: false,
                        autovalidate: true,
                        validator: (_) {
                          return !registerState.isValidPassword ? 'Invalid Password' : null;
                        },
                      ),
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                    ),
                    RegisterButton(
                      onPressed: () {
                        if (isRegisterButtonEnable(registerState)) {
                          _registerBloc.add(RegisterEventPressed(
                              email: _emailController.text,
                              password: _passwordController.text));
                        }
                      },
                    )
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
