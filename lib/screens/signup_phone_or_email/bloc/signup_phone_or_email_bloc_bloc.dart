import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:snapchat/components/models/countries.dart';
import 'package:snapchat/components/models/country_code.dart';



part 'signup_phone_or_email_bloc_event.dart';
part 'signup_phone_or_email_bloc_state.dart';

class SignupPhoneOrEmailBloc
    extends Bloc<SignupPhoneOrEmailEvent, SignupPhoneOrEmailState> {
  late String _email, _phoneNumber;
  List<Country> _countries = [];
  Country _selectedCountry =
      Country(CountryCode: '', CountryName: '', CountryCodeString: '');
  SignupPhoneOrEmailBloc() : super(SignupPhoneOrEmailBlocInitial()) {
    on<ChangeScreenButtonEvent>(_onChangeScreenButtonEvent);
    on<SignUpPhoneLoadEvent>(_onSignUpPhoneLoadEvent);
    on<PhoneNextButtonEvent>(_onPhoneNextButtonEvent);
    on<EmailNextButtonEvent>(_onEmailNextButtonEvent);
    on<SelectCountryEvent>(_onSelectCountryEvent);
    on<NumberFieldEvent>(_onNumberFieldEvent);
    on<EmailFieldEvent>(_onEmailFieldEvent);
  }

  void _onSelectCountryEvent(SelectCountryEvent event, Emitter emit) {
    _selectedCountry = event.selectedCountry;
    emit(SetSelectedCountryState(selectedCountry: event.selectedCountry));
  }

  void _onChangeScreenButtonEvent(ChangeScreenButtonEvent event, Emitter emit) {
    emit(UpdateScreen(visibility: !event.visibility));
  }

  void _onNumberFieldEvent(NumberFieldEvent event, Emitter emit) {
    _phoneNumber = event.phoneNumber;
    emit(UpdatePhoneValid(numberIsValid: _validNumber));
  }

  void _onEmailFieldEvent(EmailFieldEvent event, Emitter emit) {
    _email = event.email;
    emit(UpdateEmailValid(emailISValid: _validEmail));
  }

  void _onPhoneNextButtonEvent(PhoneNextButtonEvent event, Emitter emit) {
    emit(UpdateUserState(
        emailorphonenumber: _selectedCountry.CountryCode + _phoneNumber));
  }

  void _onEmailNextButtonEvent(EmailNextButtonEvent event, Emitter emit) {
    emit(UpdateUserState(emailorphonenumber: _email));
  }

  Future<void> _onSignUpPhoneLoadEvent(
      SignUpPhoneLoadEvent event, Emitter emit) async {
    await _loadJsonData(emit);
    emit(SetCountriesState(
        countries: _countries, selectedCountry: _selectedCountry));
  }

  Future<void> _loadJsonData(Emitter emit) async {
    var jsonText;
    try {
      jsonText = await http
          .get(Uri.parse('https://parentstree-server.herokuapp.com/countries'));
      if (jsonText.statusCode == 200) {
        final data = json.decode(jsonText.body) as Map<String, dynamic>;
        final countries = Countries.fromJson(data);
        _countries = countries.countries;
        await _selectUserCountry(emit);
      } else {
        emit(ShowErrorAlertState(erorrMsg: 'Erorr ${jsonText.statusCode}'));
      }
    } on SocketException catch (_) {
      emit(ShowErrorAlertState(erorrMsg: 'No internet'));
    }
  }

  Future<void> _selectUserCountry(Emitter emit) async {
    try {
      final locale = await http.get(Uri.parse('http://ip-api.com/json'));
      if (locale.statusCode == 200) {
        final currentCountry =
            json.decode(locale.body)['countryCode'].toString();
        _selectedCountry = _countries.firstWhere((dynamic country) =>
            country.CountryCodeString.contains(currentCountry));
      } else {
        emit(ShowErrorAlertState(erorrMsg: 'Erorr ${locale.statusCode}'));
      }
    } on SocketException catch (_) {
      emit(ShowErrorAlertState(erorrMsg: 'No internet'));
    }
  }

  bool get _validEmail {
    final regex = RegExp(
        r"[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z0-9][a-zA-Z0-9]*$");
    if (_email.isEmpty || !regex.hasMatch(_email)) {
      return false;
    }
    return true;
  }

  bool get _validNumber {
    if (_phoneNumber.isNotEmpty) {
      return true;
    }
    return false;
  }
}
