part of 'sign_up_birtday_bloc.dart';

abstract class SignUpBirtdayEvent {}

class NextButtonEvent extends SignUpBirtdayEvent {}

class SignUpBirtdayLoadEvent extends SignUpBirtdayEvent {}

class DatePickerEvent extends SignUpBirtdayEvent {
  final DateTime SelectDate;
  DatePickerEvent({required this.SelectDate});
}
