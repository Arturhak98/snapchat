import 'package:bloc/bloc.dart';
import 'package:snapchat/components/models/country_code.dart';
import 'package:snapchat/middle_wares/repositories/api_repository.dart';
import 'package:snapchat/middle_wares/repositories/sql_database_repository.dart';
import 'package:snapchat/middle_wares/repositories/validation_repository.dart';
part 'signup_phone_or_email_event.dart';
part 'signup_phone_or_email_state.dart';

class SignupPhoneOrEmailBloc
    extends Bloc<SignupPhoneOrEmailEvent, SignupPhoneOrEmailState> {
  final ValidationRepository validation;
  final SqlDatabaseRepository sqlrepository;
  final ApiRepository apirepository;
  SignupPhoneOrEmailBloc(
      {required this.validation,
      required this.sqlrepository,
      required this.apirepository})
      : super(SignupPhoneOrEmailBlocInitial()) {
    on<PhoneNextButtonEvent>(_onPhoneNextButtonEvent);
    on<EmailNextButtonEvent>(_onEmailNextButtonEvent);
    on<SignUpPhoneLoadEvent>(_onSignUpPhoneLoadEvent);
    on<NumberFieldEvent>(_onNumberFieldEvent);
    on<EmailFieldEvent>(_onEmailFieldEvent);
  }
   Future<void> _onEmailNextButtonEvent(EmailNextButtonEvent event,Emitter emit) async{
     final check = await apirepository.checkEmail(event.email);
    if (check) {
      emit(UpdateUserState());
    } else {
      emit(ShowErrorAlertState(errorMsg: 'Email is Busy'));
    }
  }

  Future<void> _onPhoneNextButtonEvent(PhoneNextButtonEvent event,Emitter emit) async{
     final check = await apirepository.checkPhone(event.phone);
    if (check) {
      emit(UpdateUserState());
    } else {
      emit(ShowErrorAlertState(errorMsg: 'Phone Number is Busy'));
    }
  }

  void _onNumberFieldEvent(NumberFieldEvent event, Emitter emit) {
    emit(UpdatePhoneValid(
        numberIsValid: validation.isNumberValid(event.phoneNumber)));
  }

  void _onEmailFieldEvent(EmailFieldEvent event, Emitter emit) {
    emit(UpdateEmailValid(emailISValid: validation.isEmailValid(event.email)));
  }

  Future<void> _onSignUpPhoneLoadEvent(
      SignUpPhoneLoadEvent event, Emitter emit) async {
    try {
      final countries = await sqlrepository.getCountries(
        '',
      );
      emit(SetCountriesState(
          countries: countries,
          selectedCountry: await apirepository.selectUserCountry(countries)));
    } catch (e) {
      emit(ShowErrorAlertState(errorMsg: e.toString()));
    }
  }
}
