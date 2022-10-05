import 'package:bloc/bloc.dart';
import 'package:snapchat/components/models/user.dart';




part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  late String _pass, _username;
  List<User> _users = [];
  LoginBloc() : super(LoginInitial()) {
    on<NameFieldEvent>(_onNameFieldEvent);
    on<PassFieldEvent>(_onPassFieldEvent);
    on<NextButtonEvent>(_onNextButtonEvent);
    on<LoginScrenLoadEvent>(_onLoginScrenLoadEvent);
    on<ObscureButtonEvent>(_onObscureButtonEvent);
  }
void _onObscureButtonEvent(ObscureButtonEvent event ,Emitter emit){
  emit(PassObscureState(passIsObscured: !event.passIsObscured));
}

  void _onLoginScrenLoadEvent(LoginScrenLoadEvent event, Emitter emit) {
    _users = event.users;
  }

  void _onNextButtonEvent(NextButtonEvent event, Emitter emit) {
    var loginUser; 
    bool usernameAndPassIsValid;
    _users.forEach((User user) {
      if (user.userName == _username && user.password == _pass) {
        loginUser = user;
      }
    });
     if (loginUser != null) {
      usernameAndPassIsValid = true;
    } else {
      usernameAndPassIsValid = false;
      loginUser=User();
    } 
    emit(UserNameAndPassValidState(entryallow: usernameAndPassIsValid,loginUser: loginUser));
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
