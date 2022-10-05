part of 'sign_up_username_bloc.dart';

abstract class SignUpUsernameEvent {}

class NextButtonEvent extends SignUpUsernameEvent {}

class UsernameFieldEvent extends SignUpUsernameEvent {
  String username;
  UsernameFieldEvent({required this.username});
}
