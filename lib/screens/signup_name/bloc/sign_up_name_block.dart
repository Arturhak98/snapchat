import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snapchat/middle_wares/validation_repository.dart';
part 'sign_up_name_event.dart';
part 'sign_up_name_state.dart';

class SignUpNameBloc extends Bloc<SignUpNameEvent, SignUpNameState> {
  ValidationRepository validation;
  SignUpNameBloc({required this.validation}) : super(SignUpNameInitial()) {
    on<LastNameFieldEvent>(_onLastNameFieldEvent);
    on<NameFieldEvent>(_onNameFieldEvent);
  }
  void _onNameFieldEvent(NameFieldEvent event, Emitter emit) {
    emit(UpdateNameValid(isNameValid: validation.isNameValid(event.name)));
  }

  void _onLastNameFieldEvent(LastNameFieldEvent event, Emitter emit) {
    emit(UpdateLastNameValid(
        isLastNameValid: validation.isNameValid(event.lastName)));
  }
}
