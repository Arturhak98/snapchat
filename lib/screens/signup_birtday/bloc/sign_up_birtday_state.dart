part of 'sign_up_birtday_bloc.dart';

abstract class SignUpBirtdayState {}

class SignUpBirtdayInitial extends SignUpBirtdayState {}

class UpdateBirtdayValid extends SignUpBirtdayState {
  final bool birtdayValid;
  final String seleqtedDate;
  UpdateBirtdayValid({required this.birtdayValid, required this.seleqtedDate});
}

class SetDateState extends SignUpBirtdayState {
  final DateTime birtday;
  final String birtdayText;
  SetDateState({required this.birtday, required this.birtdayText});
}

class UpdateUserState extends SignUpBirtdayState {
  final DateTime birtday;
  UpdateUserState({required this.birtday});
}
