import 'package:bloc/bloc.dart';
import 'package:snapchat/components/models/country_code.dart';
import 'package:snapchat/middle_wares/repositories/api_repository.dart';
import 'package:snapchat/middle_wares/repositories/sql_database_repository.dart';
import 'package:snapchat/middle_wares/repositories/validation_repository.dart';
part 'signup_phone_or_email_bloc_event.dart';
part 'signup_phone_or_email_state.dart';

class SignupPhoneOrEmailBloc
    extends Bloc<SignupPhoneOrEmailEvent, SignupPhoneOrEmailState> {
 final ValidationRepository validation;
 final SqlDatabaseRepository sqlrepository ;
 final ApiRepository api;
  SignupPhoneOrEmailBloc({required this.validation,required this.api,required this.sqlrepository})
      : super(SignupPhoneOrEmailBlocInitial()) {
    on<SignUpPhoneLoadEvent>(_onSignUpPhoneLoadEvent);
    on<NumberFieldEvent>(_onNumberFieldEvent);
    on<EmailFieldEvent>(_onEmailFieldEvent);
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
        try{
    final countries = await sqlrepository.getCountries('',);
    emit(SetCountriesState(
        countries: countries,
        selectedCountry: await api.selectUserCountry( countries)));}
        catch(e){
          emit(ShowErrorAlertState(erorrMsg: e.toString()));
        }
  }
}
