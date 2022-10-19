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


