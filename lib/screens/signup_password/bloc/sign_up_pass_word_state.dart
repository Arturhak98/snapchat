part of 'sign_up_pass_word_bloc.dart';
abstract class SignUpPassWordState {}

class SignUpPassWordInitial extends SignUpPassWordState {}

class UpdatePassValid extends SignUpPassWordState {
  final bool isPassValid;
  UpdatePassValid({required this.isPassValid});
}
