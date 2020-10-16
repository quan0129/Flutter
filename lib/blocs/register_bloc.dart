import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:FireBaseDemo/respositories/user_reposity.dart';
import 'package:FireBaseDemo/validators/validatetors.dart';
import 'package:FireBaseDemo/states/register_state.dart';
import 'package:FireBaseDemo/events/register_event.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final UserRepository _userRepository;
  RegisterBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(RegisterState.initial());

  @override
  Stream<Transition<RegisterEvent, RegisterState>> transformEvents(
    Stream<RegisterEvent> events,
    TransitionFunction<RegisterEvent, RegisterState> transitionFn,
  ) {
    final nonDebouncesStream = events.where((event) {
      return (event is! RegisterEventEmailChange &&
          event is! RegisterEventPasswordChange);
    });
    final debounceStream = events.where((event) {
      return (event is RegisterEventEmailChange ||
          event is RegisterEventPasswordChange);
    }).debounceTime(Duration(milliseconds: 300));
    return super.transformEvents(
        nonDebouncesStream.mergeWith([debounceStream]), transitionFn);
  }

  @override
  Stream<RegisterState> mapEventToState(RegisterEvent registerEvent) async* {
    if (registerEvent is RegisterEventEmailChange) {
      yield state.cloneAndUpdate(
          isValidEmail: Validators.isValidEmail(registerEvent.email));
    } else if (registerEvent is RegisterEventPasswordChange) {
      yield state.cloneAndUpdate(
          isValidPassword: Validators.isValidPassword(registerEvent.password));
    } else if (registerEvent is RegisterEventPressed) {
      yield RegisterState.loading();
      try {
        await _userRepository.createUserWithEmailAndPassword(
            registerEvent.email, registerEvent.password);
        yield RegisterState.success();
      } catch (exception) {
        yield RegisterState.failure();
      }
    }
  }
}
