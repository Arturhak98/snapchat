part of 'sign_up_username_bloc.dart';

abstract class SignUpUsernameEvent {}

class NextButtonEvent extends SignUpUsernameEvent {
  String userName;
  NextButtonEvent({required this.userName});
}

class UsernameFieldEvent extends SignUpUsernameEvent {
  String username;
  UsernameFieldEvent({required this.username});
}
