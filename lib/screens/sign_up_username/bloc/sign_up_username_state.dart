part of 'sign_up_username_bloc.dart';

abstract class SignUpUsernameState {}

class SignUpUsernameInitial extends SignUpUsernameState {}

class UpdateUsernameValid extends SignUpUsernameState {
  final bool isUsernameValid;
  UpdateUsernameValid({required this.isUsernameValid});
}
class AlertError extends SignUpUsernameState {
  String error;
  AlertError({required this.error});
}
class UserNameIsFree extends SignUpUsernameState{}