import 'package:bloc/bloc.dart';
part 'sign_up_username_event.dart';
part 'sign_up_username_state.dart';

class SignUpUsernameBloc
    extends Bloc<SignUpUsernameEvent, SignUpUsernameState> {
  late String _username;

  SignUpUsernameBloc() : super(SignUpUsernameInitial()) {
    on<UsernameFieldEvent>(_onUsernameFieldEvent);
    on<NextButtonEvent>(_onNextButtonEvent);
  }

  void _onNextButtonEvent(NextButtonEvent event, Emitter emit) {
    emit(UpdateUserState(username: _username));
  }

  void _onUsernameFieldEvent(UsernameFieldEvent event, Emitter emit) {
    _username = event.username;
    emit(UpdateUsernameValid(isUsernameValid: _isValid));
  }

  bool get _isValid {
    if (_username.length >= 5) {
      return true;
    }
    return false;
  }
}
