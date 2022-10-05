part of 'sign_up_pass_word_bloc.dart';
abstract class SignUpPassWordState {}

class SignUpPassWordInitial extends SignUpPassWordState {}

class UpdatePassValid extends SignUpPassWordState {
  final bool isPassValid;
  UpdatePassValid({required this.isPassValid});
}

class UpdateUserState extends SignUpPassWordState {
  final String password;
  UpdateUserState({required this.password});
}
class HidePassState extends SignUpPassWordState{
  final bool passIsHide;
  HidePassState({required this.passIsHide});
}