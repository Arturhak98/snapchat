import 'package:bloc/bloc.dart';
import 'package:snapchat/components/models/user.dart';
import 'package:snapchat/middle_wares/repositories/api_repository.dart';
//import 'package:snapchat/middle_wares/repositories/api_repository.dart';
import 'package:snapchat/middle_wares/repositories/sql_database_repository.dart';
import 'package:snapchat/middle_wares/repositories/validation_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final ValidationRepository validation;
  final SqlDatabaseRepository sqldb;

  LoginBloc({required this.validation, required this.sqldb})
      : super(LoginInitial()) {
    on<NameFieldEvent>(_onNameFieldEvent);
    on<PassFieldEvent>(_onPassFieldEvent);
    on<NextButtonEvent>(_onNextButtonEvent);
  }

  Future<void> _onNextButtonEvent(NextButtonEvent event, Emitter emit) async {
    final apirepo= ApiRepository();
    final user= await apirepo.login(event.userName, event.password);
  //  final apirepo= ApiRepository();
   // final user= await apirepo.login(event.userName, event.password);
   // final b=await apirepo.checkConnection();
   // apirepo.validate(event.userName, event.password);
   // final user = await sqldb.getUser(event.userName, event.password);
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
