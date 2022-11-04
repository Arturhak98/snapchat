part of 'login_bloc.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class UpdateNameValid extends LoginState {
  final bool isUserNameValid;
  UpdateNameValid({required this.isUserNameValid});
}

class UpdatePassValid extends LoginState {
  final bool IsPassValid;
  UpdatePassValid({required this.IsPassValid});
}

class UserNameAndPassValidState extends LoginState {
  final User loginUser;
  UserNameAndPassValidState({required this.loginUser});
}

class AlertError extends LoginState {
  String error;
  AlertError({required this.error});
}
