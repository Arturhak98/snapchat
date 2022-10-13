import 'package:bloc/bloc.dart';
import 'package:snapchat/components/models/user.dart';
import 'package:snapchat/middle_wares/sql_database_repository.dart';
import 'package:snapchat/middle_wares/validation_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  ValidationRepository validation;
  LoginBloc({required this.validation}) : super(LoginInitial()) {
    on<NameFieldEvent>(_onNameFieldEvent);
    on<PassFieldEvent>(_onPassFieldEvent);
    on<NextButtonEvent>(_onNextButtonEvent);
  }

  Future<void> _onNextButtonEvent(NextButtonEvent event, Emitter emit) async {
    final sqldb = SqlDatabaseRepository();
    final user= await sqldb.getUser(event.userName, event.password);
    if (user == null) {
      emit(UserNameOrPassIsNotValid());
    } else {
      emit(UserNameAndPassValidState(loginUser: user));
    }
  }

  void _onPassFieldEvent(PassFieldEvent event, Emitter emit) {
    emit(UpdatePassValid(IsPassValid: validation.isPassValid(event.pass)));
  }

  void _onNameFieldEvent(NameFieldEvent event, Emitter emit) {
    emit(UpdateNameValid(
        isUserNameValid: validation.isUsernameValid(event.userName)));
  }
}
