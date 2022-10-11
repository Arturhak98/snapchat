import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:snapchat/components/models/user.dart';
import 'package:snapchat/middle_wares/database.dart';
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
    final query = await DataBase.getUser(event.userNameController.text);
    if (query.isNotEmpty) {
      final user = User.fromMap(query.first);
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
    emit(UpdatePassValid(IsPassValid: validation.isPassValid(event.pass)));
  }

  void _onNameFieldEvent(NameFieldEvent event, Emitter emit) {
    emit(UpdateNameValid(
        isUserNameValid: validation.isUsernameValid(event.userName)));
  }
}
