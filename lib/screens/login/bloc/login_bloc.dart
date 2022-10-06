import 'package:bloc/bloc.dart';
import 'package:snapchat/components/models/user.dart';
import 'package:snapchat/middle_wares/database.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  late String _pass, _username;
  LoginBloc() : super(LoginInitial()) {
    on<NameFieldEvent>(_onNameFieldEvent);
    on<PassFieldEvent>(_onPassFieldEvent);
    on<NextButtonEvent>(_onNextButtonEvent);
    on<LoginScrenLoadEvent>(_onLoginScrenLoadEvent);
    on<ObscureButtonEvent>(_onObscureButtonEvent);
  }
  void _onObscureButtonEvent(ObscureButtonEvent event, Emitter emit) {
    emit(PassObscureState(passIsObscured: !event.passIsObscured));
  }

  void _onLoginScrenLoadEvent(LoginScrenLoadEvent event, Emitter emit) {}

  Future<void> _onNextButtonEvent(NextButtonEvent event, Emitter emit) async {
    var query;
    var user;
    await DataBase.getUser(_username).then((value) => query = value);
    if (query.isNotEmpty) {
      user = User.fromMap(query.first);
      if (user.password == _pass) {
        emit(UserNameAndPassValidState(loginUser: user));
      } else {
        emit(UserNameOrPassIsNotValid());
      }
    } else {
      emit(UserNameOrPassIsNotValid());
    }
  }

  void _onPassFieldEvent(PassFieldEvent event, Emitter emit) {
    _pass = event.pass;
    emit(UpdatePassValid(IsPassValid: _isPassValid));
  }

  void _onNameFieldEvent(NameFieldEvent event, Emitter emit) {
    _username = event.userName;
    emit(UpdateNameValid(isUserNameValid: _isUsernameValid));
  }

  bool get _isPassValid {
    if (_pass.length >= 8) {
      return true;
    } else {
      return false;
    }
  }

  bool get _isUsernameValid {
    if (_username.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }
}
