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
class UserNameAndPassValidState extends LoginState{
  /* final bool entryallow; */
  final User loginUser;
UserNameAndPassValidState({/* required this.entryallow, */required this.loginUser});
}
class PassObscureState extends LoginState{
  final passIsObscured;
  PassObscureState({required this.passIsObscured}); 
}
class UserNameOrPassIsNotValid extends LoginState{}