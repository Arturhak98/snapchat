part of 'sign_up_pass_word_bloc.dart';
abstract class SignUpPassWordState {}

class SignUpPassWordInitial extends SignUpPassWordState {}

class UpdatePassValid extends SignUpPassWordState {
  final bool isPassValid;
  UpdatePassValid({required this.isPassValid});
  
}
class UserAddedState extends SignUpPassWordState{}
class ErrorAlertState extends SignUpPassWordState{
  String error;
  ErrorAlertState({required this.error});
}
