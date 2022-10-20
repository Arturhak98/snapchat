part of 'login_bloc.dart';

abstract class LoginEvent {}

class NextButtonEvent extends LoginEvent {
  String password;
  String userName;
  NextButtonEvent({required this.password, required this.userName});
}

class NameFieldEvent extends LoginEvent {
  String userName;
  NameFieldEvent({required this.userName});
}

class PassFieldEvent extends LoginEvent {
  String pass;
  PassFieldEvent({required this.pass});
}
