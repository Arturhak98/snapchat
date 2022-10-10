part of 'sign_up_birtday_bloc.dart';

abstract class SignUpBirtdayEvent {}

class DatePickerEvent extends SignUpBirtdayEvent {
  final DateTime selectDate;
  DatePickerEvent({required this.selectDate});
}
