part of 'signup_phone_or_email_bloc_bloc.dart';

abstract class SignupPhoneOrEmailEvent {}

class SignUpPhoneLoadEvent extends SignupPhoneOrEmailEvent {}

class EmailNextButtonEvent extends SignupPhoneOrEmailEvent {}

class PhoneNextButtonEvent extends SignupPhoneOrEmailEvent {}

class SelectCountryEvent extends SignupPhoneOrEmailEvent {
  Country selectedCountry;
  SelectCountryEvent({required this.selectedCountry});
}

class NumberFieldEvent extends SignupPhoneOrEmailEvent {
  String phoneNumber;
  NumberFieldEvent({required this.phoneNumber});
}

class EmailFieldEvent extends SignupPhoneOrEmailEvent {
  String email;
  EmailFieldEvent({required this.email});
}

class ChangeScreenButtonEvent extends SignUpPhoneLoadEvent {
  bool visibility;
  ChangeScreenButtonEvent({required this.visibility});
}
