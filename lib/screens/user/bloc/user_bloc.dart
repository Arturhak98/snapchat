import 'package:bloc/bloc.dart';
import 'package:snapchat/components/models/user.dart';
import 'package:snapchat/middle_wares/repositories/api_repository.dart';
import 'package:snapchat/middle_wares/repositories/sql_database_repository.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  ApiRepository apiRepository;
  SqlDatabaseRepository sqlDatabaseRepository;
  UserBloc({required this.apiRepository, required this.sqlDatabaseRepository})
      : super(UserInitial()) {
    on<LogOutEvent>(_onLogOutEvent);
    on<DeleteEvent>(_onDeleteEvent);
    on<UserScreenLoadEvent>(_onUserScreenLoadEvent);
  }
  Future<void> _onLogOutEvent(LogOutEvent event, Emitter emit) async {
    await sqlDatabaseRepository.Logout();
    emit(LogOutState());
  }

  Future<void> _onDeleteEvent(DeleteEvent event, Emitter emit) async {
    final deleted = await apiRepository.deleteUser();
    if (deleted) {
      sqlDatabaseRepository.deleteUser();
      emit(DeleteState());
    } else {
      emit(ShowErrorAler(error: 'ERROR'));
    }
  }

  Future<void> _onUserScreenLoadEvent(
      UserScreenLoadEvent event, Emitter emit) async {
    try {
      final user = await apiRepository.upDateUser();
      if (user != null) {
        sqlDatabaseRepository.editUser(user);
        emit(ScreenLoadedState(user: user));
      }
    } catch (e) {
      emit(ShowErrorAler(error: e.toString()));
    } /* else {
      emit(ShowErrorAler(error: 'ERROR'));
    } */
  }
}
