import 'package:FireBaseDemo/respositories/user_reposity.dart';
import 'package:FireBaseDemo/states/login_state.dart';
import 'package:FireBaseDemo/validators/validatetors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:FireBaseDemo/events/login_event.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  UserRepository _userRepository;
  LoginBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(LoginState.initial());
  @override
  Stream<Transition<LoginEvent, LoginState>> tranformEvents(
      Stream<LoginEvent> loginEvents,
      TransitionFunction<LoginEvent, LoginState> transitionFunction) {
    final debouncesStream = loginEvents.where((loginEvent) {
      return (loginEvent is LoginEventEmailChange ||
          loginEvent is LoginEventPasswordChange);
    }).debounceTime(Duration(microseconds: 300));
    final nonDebounceStream = loginEvents.where((loginEvent) {
      return (loginEvent is LoginEventEmailChange ||
          loginEvent is LoginEventPasswordChange);
    });
    return super.transformEvents(
        nonDebounceStream.mergeWith([debouncesStream]), transitionFunction);
  }

  @override
  Stream<LoginState> mapEventToState(LoginEvent loginEvent) async* {
    final loginState = state; // for easier to read code purpose
    if (loginEvent is LoginEventEmailChange) {
      yield loginState.cloneAndUpdate(
          isValidEmail: Validators.isValidEmail(loginEvent.email));
    } else if (loginEvent is LoginEventPasswordChange) {
      yield loginState.cloneAndUpdate(
          isValidPassword: Validators.isValidPassword(loginEvent.password));
    } else if (loginEvent is LoginEventWithGooglePressed) {
      try {
        await _userRepository.signInWithGoogle();
        yield LoginState.success();
      } catch (_) {
        yield LoginState.failure();
      }
    } else if (loginEvent is LoginEventWithEmailAndPasswordPressed) {
      try {
        await _userRepository.signInWithEmailAndPassword(
            loginEvent.email, loginEvent.password);
        yield LoginState.success();
      } catch (_) {
        yield LoginState.failure();
      }
    }
  }
}
