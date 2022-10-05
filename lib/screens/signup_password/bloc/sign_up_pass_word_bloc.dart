import 'package:bloc/bloc.dart';

part 'sign_up_pass_word_event.dart';
part 'sign_up_pass_word_state.dart';

class SignUpPassWordBloc extends Bloc<SignUpPassWordEvent, SignUpPassWordState> {
  late String _pass;
  SignUpPassWordBloc() : super(SignUpPassWordInitial()) {
    on<PassFieldEvent>(_onPassFieldEvent);
    on<NextButtonEvent>(_onNextButtonEvent);
    on<HidePassEvent>(_onHidePassEvent);
  }
  void _onHidePassEvent(HidePassEvent event , Emitter emit){
    emit(HidePassState(passIsHide: !event.hidepass));
  }
  void _onNextButtonEvent(NextButtonEvent event ,Emitter emit){
    emit(UpdateUserState(password: _pass));
  }
  void _onPassFieldEvent(PassFieldEvent event, Emitter emit){
    _pass=event.pass;
    emit(UpdatePassValid(isPassValid: _isValid));
  }
    bool get _isValid {
    if (_pass.length >= 8) {
      return true;
    }
    return false;
  }
}
