part of 'signup_phone_or_email_bloc_bloc.dart';

abstract class SignupPhoneOrEmailState {}

class SignupPhoneOrEmailBlocInitial extends SignupPhoneOrEmailState {}

class UpdateEmailValid extends SignupPhoneOrEmailState {
  bool emailISValid;
  UpdateEmailValid({required this.emailISValid});
}

class ShowErrorAlertState extends SignupPhoneOrEmailState{
  String erorrMsg;
  ShowErrorAlertState({required this.erorrMsg});
}

class UpdatePhoneValid extends SignupPhoneOrEmailState {
  bool numberIsValid;
  UpdatePhoneValid({required this.numberIsValid});
}

class SetCountriesState extends SignupPhoneOrEmailState{
    List<Country> countries;
   Country selectedCountry;
   SetCountriesState({required this.countries, required this.selectedCountry});
}

class UpdateUserState extends SignupPhoneOrEmailState {
  String emailorphonenumber;
  UpdateUserState({required this.emailorphonenumber});
}

class UpdateScreen extends SignupPhoneOrEmailState{
  bool visibility;
  UpdateScreen({required this.visibility});
}

class SetSelectedCountryState extends SignupPhoneOrEmailState{
  Country selectedCountry;
  SetSelectedCountryState({required this.selectedCountry});
}

