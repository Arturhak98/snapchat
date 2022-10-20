part of 'signup_phone_or_email_bloc.dart';

abstract class SignupPhoneOrEmailEvent {}

class SignUpPhoneLoadEvent extends SignupPhoneOrEmailEvent {}

class NumberFieldEvent extends SignupPhoneOrEmailEvent {
  String phoneNumber;
  NumberFieldEvent({required this.phoneNumber});
}

class EmailFieldEvent extends SignupPhoneOrEmailEvent {
  String email;
  EmailFieldEvent({required this.email});
}
class EmailNextButtonEvent extends SignupPhoneOrEmailEvent{
  String email;
  EmailNextButtonEvent({required this.email});
}
class PhoneNextButtonEvent extends SignupPhoneOrEmailEvent{
  String phone;
  PhoneNextButtonEvent({required this.phone});
}

