import 'package:bloc/bloc.dart';
import 'package:snapchat/middle_wares/database.dart';
import 'package:snapchat/middle_wares/validation_repository.dart';
part 'sign_up_username_event.dart';
part 'sign_up_username_state.dart';

class SignUpUsernameBloc
    extends Bloc<SignUpUsernameEvent, SignUpUsernameState> {
  ValidationRepository validation;
  SignUpUsernameBloc({required this.validation})
      : super(SignUpUsernameInitial()) {
    on<UsernameFieldEvent>(_onUsernameFieldEvent);
    on<NextButtonEvent>(_onNextButtonEvent);
  }

  Future<void> _onNextButtonEvent(NextButtonEvent event, Emitter emit) async {
    final query = await DataBase.getUser(event.userName);
    if (query.isNotEmpty) {
      emit(UsernameIsBusy());
    } else {
      emit(UpdateUserState());
    }
  }

  void _onUsernameFieldEvent(UsernameFieldEvent event, Emitter emit) {
    emit(UpdateUsernameValid(
        isUsernameValid: validation.isUsernameValid(event.username)));
  }
}
