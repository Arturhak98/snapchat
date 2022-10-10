import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:snapchat/components/models/user.dart';
import 'package:snapchat/middle_wares/database.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  
  LoginBloc() : super(LoginInitial()) {
    on<NameFieldEvent>(_onNameFieldEvent);
    on<PassFieldEvent>(_onPassFieldEvent);
    on<NextButtonEvent>(_onNextButtonEvent);

  
  }




  Future<void> _onNextButtonEvent(NextButtonEvent event, Emitter emit) async {
    var query;
    var user;
    await DataBase.getUser(event.userNameController.text).then((value) => query = value);
    if (query.isNotEmpty) {
      user = User.fromMap(query.first);
      if (user.password == event.passController.text) {
        emit(UserNameAndPassValidState(loginUser: user));
      } else {
        emit(UserNameOrPassIsNotValid());
      }
    } else {
      emit(UserNameOrPassIsNotValid());
    }
  }

  void _onPassFieldEvent(PassFieldEvent event, Emitter emit) {
    emit(UpdatePassValid(IsPassValid: _isPassValid(event.pass)));
  }

  void _onNameFieldEvent(NameFieldEvent event, Emitter emit) {
    emit(UpdateNameValid(isUserNameValid: _isUsernameValid(event.userName)));
  }

  bool _isPassValid(String pass) {
    if (pass.length >= 8) {
      return true;
    } else {
      return false;
    }
  }

  bool _isUsernameValid(String username) {
    if (username.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }
}
