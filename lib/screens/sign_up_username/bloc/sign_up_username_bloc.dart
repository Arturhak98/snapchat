import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:snapchat/middle_wares/repositories/api_repository.dart';
import 'package:snapchat/middle_wares/repositories/validation_repository.dart';

part 'sign_up_username_event.dart';
part 'sign_up_username_state.dart';

class SignUpUsernameBloc
    extends Bloc<SignUpUsernameEvent, SignUpUsernameState> {
  final ValidationRepository validation;
  final ApiRepository apiRepository;
  SignUpUsernameBloc({required this.validation, required this.apiRepository})
      : super(SignUpUsernameInitial()) {
    on<UsernameFieldEvent>(_onUsernameFieldEvent,
        transformer: ((events, mapper) => events
            .debounceTime(const Duration(milliseconds: 100))
            .switchMap((mapper))));
  }
  Future<void> _onUsernameFieldEvent(
      UsernameFieldEvent event, Emitter emit) async {
    {
      final valid = validation.isUsernameValid(event.username);
      if (valid) {
        try {
          await apiRepository.checkUserName(event.username);
          emit(UserNameIsFree());
        } catch (e) {
          emit(AlertError(error: e.toString()));
        }
      }
      emit(UpdateUsernameValid(isUsernameValid: valid));
    }
  }
}
