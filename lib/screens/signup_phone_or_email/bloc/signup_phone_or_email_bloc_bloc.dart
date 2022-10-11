import 'package:bloc/bloc.dart';
import 'package:snapchat/components/models/country_code.dart';
import 'package:snapchat/middle_wares/api_repository.dart';
import 'package:snapchat/middle_wares/validation_repository.dart';
part 'signup_phone_or_email_bloc_event.dart';
part 'signup_phone_or_email_state.dart';

class SignupPhoneOrEmailBloc
    extends Bloc<SignupPhoneOrEmailEvent, SignupPhoneOrEmailState> {
  ValidationRepository validation;
  SignupPhoneOrEmailBloc({required this.validation})
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
    final api = ApiRepository();
    final countries = await api.loadJsonData(emit);
    emit(SetCountriesState(
        countries: countries,
        selectedCountry: await api.selectUserCountry(emit, countries)));
  }
}
