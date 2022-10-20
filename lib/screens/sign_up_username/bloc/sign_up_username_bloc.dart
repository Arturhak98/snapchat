import 'package:bloc/bloc.dart';
import 'package:snapchat/middle_wares/repositories/api_repository.dart';
import 'package:snapchat/middle_wares/repositories/validation_repository.dart';
part 'sign_up_username_event.dart';
part 'sign_up_username_state.dart';

class SignUpUsernameBloc
    extends Bloc<SignUpUsernameEvent, SignUpUsernameState> {
  final ValidationRepository validation;
 // final SqlDatabaseRepository sqldb;
  final ApiRepository apiRepository;
  SignUpUsernameBloc({required this.validation,required this.apiRepository})
      : super(SignUpUsernameInitial()) {
    on<UsernameFieldEvent>(_onUsernameFieldEvent);
    on<NextButtonEvent>(_onNextButtonEvent);
  }

  Future<void> _onNextButtonEvent(NextButtonEvent event, Emitter emit) async {
    //final busy = await sqldb.getUserName(event.userName);
    final check=await apiRepository.checkUserName(event.userName);
    if (check) {
      emit(UpdateUserState());
    } else {
      emit(UsernameIsBusy());
    }
  }

  void _onUsernameFieldEvent(UsernameFieldEvent event, Emitter emit) {
    emit(UpdateUsernameValid(
        isUsernameValid: validation.isUsernameValid(event.username)));
  }
}
