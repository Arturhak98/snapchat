import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';
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
    on<SignUpPhoneLoadEvent>(_onSignUpPhoneLoadEvent,
        transformer: ((events, mapper) => events
            .debounceTime(const Duration(milliseconds: 100))
            .switchMap((mapper))));
    on<NumberFieldEvent>(_onNumberFieldEvent,
        transformer: ((events, mapper) => events
            .debounceTime(const Duration(milliseconds: 100))
            .switchMap((mapper))));
    on<EmailFieldEvent>(_onEmailFieldEvent);
  }

  Future<void> _onNumberFieldEvent(NumberFieldEvent event, Emitter emit) async {
    final valid = validation.isNumberValid(event.phoneNumber);
    if (valid) {
      try {
        await apirepository.checkPhone(event.countryCode + event.phoneNumber);
        emit(PhoneIsFree());
      } catch (e) {
        emit(ShowErrorAlertState(errorMsg: e.toString()));
      }
    }
    emit(UpdatePhoneValid(numberIsValid: valid));
  }
  
  Future<void> _onEmailFieldEvent(EmailFieldEvent event, Emitter emit) async {
    final valid = validation.isEmailValid(event.email);
    if (valid) {
      try {
        await apirepository.checkEmail(event.email);
        emit(EmailIsFree());
      } catch (e) {
        emit(ShowErrorAlertState(errorMsg: e.toString()));
      }
    }
    emit(UpdateEmailValid(emailISValid: valid));
  }

  Future<void> _onSignUpPhoneLoadEvent(
      SignUpPhoneLoadEvent event, Emitter emit) async {
    try {
      var countries = await sqlrepository.getCountries();
      if (countries.isEmpty) {
        countries = await apirepository.loadJsonData();
        await sqlrepository.setCountries(countries);
      }
      emit(SetCountriesState(
          countries: countries,
          selectedCountry: await apirepository.selectUserCountry(countries)));
    } catch (e) {
      emit(ShowErrorAlertState(errorMsg: e.toString()));
    }
  }
}
