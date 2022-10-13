part of 'sign_up_name_block.dart';
abstract class SignUpNameState {}
class SignUpNameInitial extends SignUpNameState {}

class UpdateNameValid extends SignUpNameState {
  final bool isNameValid;
  UpdateNameValid({required this.isNameValid});
}

class UpdateLastNameValid extends SignUpNameState {
  final bool isLastNameValid;
  UpdateLastNameValid({required this.isLastNameValid});
}

