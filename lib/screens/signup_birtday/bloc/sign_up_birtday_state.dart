part of 'sign_up_birtday_bloc.dart';

abstract class SignUpBirtdayState {}

class SignUpBirtdayInitial extends SignUpBirtdayState {}

class UpdateBirtdayValid extends SignUpBirtdayState {
  final bool birtdayValid;
  UpdateBirtdayValid({
    required this.birtdayValid,
  });
}
