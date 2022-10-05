import 'package:bloc/bloc.dart';
import 'package:snapchat/components/models/user.dart';
import 'package:snapchat/middle_wares/database.dart';




part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  late String _pass, _username;
 /*  List<User> _users = []; */
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
    /* _users = event.users; */
  }

  Future<void> _onNextButtonEvent(NextButtonEvent event, Emitter emit)async {
  //  var loginUser; 
   bool usernameAndPassIsValid;
   // var loginUser= DataBase.getUser(_username);
  /*   _users.forEach((User user) {
      if (user.userName == _username && user.password == _pass) {
        loginUser = user;
      }
    }); */
/*      if (loginUser.isNotEmpty) {
      usernameAndPassIsValid = true;
    } else {
      usernameAndPassIsValid = false;
      loginUser=User();
    }  */
    var user;
   await DataBase.getUser(_username).then((value) =>user=value);
    if(user.password==_pass){
        usernameAndPassIsValid = true;
    }
    else{
      usernameAndPassIsValid = false;
    }
    emit(UserNameAndPassValidState(entryallow: usernameAndPassIsValid, loginUser: user));
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
