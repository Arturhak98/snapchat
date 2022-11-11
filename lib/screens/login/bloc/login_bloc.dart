import 'package:bloc/bloc.dart';
import 'package:snapchat/components/models/user.dart';
import 'package:snapchat/middle_wares/repositories/api_repository.dart';
import 'package:snapchat/middle_wares/repositories/sql_database_repository.dart';
import 'package:snapchat/middle_wares/repositories/validation_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final ValidationRepository validation;
  final SqlDatabaseRepository sqldb;
  final ApiRepository apirepo;
  LoginBloc(
      {required this.validation, required this.sqldb, required this.apirepo})
      : super(LoginInitial()) {
    on<NameFieldEvent>(_onNameFieldEvent);
    on<PassFieldEvent>(_onPassFieldEvent);
    on<NextButtonEvent>(_onNextButtonEvent);
  }

  Future<void> _onNextButtonEvent(NextButtonEvent event, Emitter emit) async {
    try {
      final user = await apirepo.login(event.userName, event.password);
      await sqldb.insert(user);
      emit(UserNameAndPassValidState(loginUser: user));
    } catch (e) {
      emit(AlertError(error: e.toString()));
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
