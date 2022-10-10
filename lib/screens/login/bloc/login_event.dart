part of 'login_bloc.dart';

abstract class LoginEvent {}

class NextButtonEvent extends LoginEvent {
  TextEditingController passController;
  TextEditingController userNameController;
  NextButtonEvent(
      {required this.passController, required this.userNameController});
}

class NameFieldEvent extends LoginEvent {
  String userName;
  NameFieldEvent({required this.userName});
}

class PassFieldEvent extends LoginEvent {
  String pass;
  PassFieldEvent({required this.pass});
}




