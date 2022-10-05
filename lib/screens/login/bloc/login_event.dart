part of 'login_bloc.dart';

abstract class LoginEvent {}


class NextButtonEvent extends LoginEvent{}

class NameFieldEvent extends LoginEvent{
  String userName;
  NameFieldEvent({required this.userName});
}
class PassFieldEvent  extends LoginEvent{
  String pass;
  PassFieldEvent({required this.pass});
}
class LoginScrenLoadEvent extends LoginEvent{
/*  /*  List<User> users; */
  LoginScrenLoadEvent({required this.users}); */
}
class ObscureButtonEvent extends LoginEvent{
  bool passIsObscured;
  ObscureButtonEvent({required this.passIsObscured});
}