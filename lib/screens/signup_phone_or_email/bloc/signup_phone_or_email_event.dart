part of 'signup_phone_or_email_bloc.dart';

abstract class SignupPhoneOrEmailEvent {}

class SignUpPhoneLoadEvent extends SignupPhoneOrEmailEvent {}

class NumberFieldEvent extends SignupPhoneOrEmailEvent {
  String countryCode;
  String phoneNumber;
  NumberFieldEvent({required this.phoneNumber,required this.countryCode});
}

class EmailFieldEvent extends SignupPhoneOrEmailEvent {
  String email;
  EmailFieldEvent({required this.email});
}


