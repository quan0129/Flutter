import 'package:FireBaseDemo/blocs/authentications_bloc.dart';
import 'package:FireBaseDemo/blocs/logon_bloc.dart';
import 'package:FireBaseDemo/events/authentication_event.dart';
import 'package:FireBaseDemo/pages/splash_page.dart';
import 'package:FireBaseDemo/states/authentication_state.dart';
import 'package:flutter/material.dart';
import 'package:FireBaseDemo/respositories/user_reposity.dart';
import 'package:FireBaseDemo/blocs/simple_bloc_observer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:FireBaseDemo/pages/home_page.dart';
import 'package:FireBaseDemo/pages/login_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final UserRepository _userRepository = UserRepository();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login with Firebase',
      home: BlocProvider(
        create: (context) => AuthenticationBloc(userRepository: _userRepository)
          ..add(AuthenticationEventStarted()),
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, authenticationState) {
            if (authenticationState is AuthenticationStateSuccess) {
              return HomePage(); //Home page
            } else if (authenticationState is AuthenticationStateFailure) {
              // Login page
              return BlocProvider<LoginBloc>(
                  create: (context) =>
                      LoginBloc(userRepository: _userRepository),
                  child: LoginPage(userRepository: _userRepository));
            }
            return SplashPage();
            // return HomePage();
          },
        ),
      ),
    );
  }
}
