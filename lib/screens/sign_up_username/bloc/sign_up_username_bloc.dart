import 'package:bloc/bloc.dart';
import 'package:snapchat/middle_wares/database.dart';
part 'sign_up_username_event.dart';
part 'sign_up_username_state.dart';

class SignUpUsernameBloc
    extends Bloc<SignUpUsernameEvent, SignUpUsernameState> {

  SignUpUsernameBloc() : super(SignUpUsernameInitial()) {
    on<UsernameFieldEvent>(_onUsernameFieldEvent);
    on<NextButtonEvent>(_onNextButtonEvent);
  }

  Future<void> _onNextButtonEvent(NextButtonEvent event, Emitter emit)async {
    var query;
   await DataBase.getUser(event.userName).then((value) => query=value);
    if(query.isNotEmpty){
      emit(UsernameIsBusy());
    }else{
      emit(UpdateUserState());
    }
  }

  void _onUsernameFieldEvent(UsernameFieldEvent event, Emitter emit) {
    emit(UpdateUsernameValid(isUsernameValid: _isValid(event.username)));
  }

  bool  _isValid(String username) {
    if (username.length >= 5) {
      return true;
    }
    return false;
  }
}
