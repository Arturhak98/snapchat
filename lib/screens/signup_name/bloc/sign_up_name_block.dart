import 'package:flutter_bloc/flutter_bloc.dart';
part 'sign_up_name_event.dart';
part 'sign_up_name_state.dart';

class SignUpNameBloc extends Bloc<SignUpNameEvent, SignUpNameState> {
  late String _name, _lastName;
  SignUpNameBloc() : super(SignUpNameInitial()) {
    on<LastNameFieldEvent>(_onLastNameFieldEvent);
    on<NextButtonEvent>(_onNextButtonEvent);
    on<NameFieldEvent>(_onNameFieldEvent);
    
  }
  void _onNameFieldEvent(NameFieldEvent event, Emitter emit) {
    _name = event.name;
    emit(UpdateNameValid(isNameValid: _isNameValid(event.name)));
  }

  void _onNextButtonEvent(NextButtonEvent event, Emitter emit) {
    emit(UpdateUserState(name: _name, lastName: _lastName));
  }

  void _onLastNameFieldEvent(LastNameFieldEvent event, Emitter emit) {
    _lastName = event.lastName;
    emit(UpdateLastNameValid(isLastNameValid: _isNameValid(event.lastName)));
  }

  bool _isNameValid(String LastName) {
    if (LastName.isNotEmpty) {
      return true;
    }
    return false;
  }

}
