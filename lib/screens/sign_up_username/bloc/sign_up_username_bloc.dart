import 'package:bloc/bloc.dart';
import 'package:snapchat/middle_wares/repositories/sql_database_repository.dart';
import 'package:snapchat/middle_wares/repositories/validation_repository.dart';
part 'sign_up_username_event.dart';
part 'sign_up_username_state.dart';

class SignUpUsernameBloc
    extends Bloc<SignUpUsernameEvent, SignUpUsernameState> {
  final ValidationRepository validation;
   final SqlDatabaseRepository sqldb;
  SignUpUsernameBloc({required this.validation,required this.sqldb})
      : super(SignUpUsernameInitial()) {
    on<UsernameFieldEvent>(_onUsernameFieldEvent);
    on<NextButtonEvent>(_onNextButtonEvent);
  }

  Future<void> _onNextButtonEvent(NextButtonEvent event, Emitter emit) async {
    final busy = await sqldb.getUserName(event.userName);
    if (busy) {
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
