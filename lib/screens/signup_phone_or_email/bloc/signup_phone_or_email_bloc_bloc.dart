import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:snapchat/components/models/countries.dart';
import 'package:snapchat/components/models/country_code.dart';
part 'signup_phone_or_email_bloc_event.dart';
part 'signup_phone_or_email_state.dart';

class SignupPhoneOrEmailBloc
    extends Bloc<SignupPhoneOrEmailEvent, SignupPhoneOrEmailState> {
  SignupPhoneOrEmailBloc() : super(SignupPhoneOrEmailBlocInitial()) {
    on<SignUpPhoneLoadEvent>(_onSignUpPhoneLoadEvent);
    on<NumberFieldEvent>(_onNumberFieldEvent);
    on<EmailFieldEvent>(_onEmailFieldEvent);
  }

  void _onNumberFieldEvent(NumberFieldEvent event, Emitter emit) {
    emit(UpdatePhoneValid(numberIsValid: _validNumber(event.phoneNumber)));
  }

  void _onEmailFieldEvent(EmailFieldEvent event, Emitter emit) {
    emit(UpdateEmailValid(emailISValid: _validEmail(event.email)));
  }

  Future<void> _onSignUpPhoneLoadEvent(
      SignUpPhoneLoadEvent event, Emitter emit) async {
    var countryes;
    var selectCountry;
    await _loadJsonData(emit).then((value) => countryes = value);
    await _selectUserCountry(emit,countryes).then((value) => selectCountry=value,);
    emit(SetCountriesState(
        countries: countryes, selectedCountry: selectCountry));
  }

  Future<List<Country>> _loadJsonData(Emitter emit) async {
    try {
      final jsonText = await http
          .get(Uri.parse('https://parentstree-server.herokuapp.com/countries'));
      if (jsonText.statusCode == 200) {
        final data = json.decode(jsonText.body) as Map<String, dynamic>;
        final countries = Countries.fromJson(data);
        return countries.countries;
      } else {
        emit(ShowErrorAlertState(erorrMsg: 'Erorr ${jsonText.statusCode}'));
      }
    } on SocketException catch (_) {
      emit(ShowErrorAlertState(erorrMsg: 'No internet'));
    }
    throw {};
  }

  Future<Country> _selectUserCountry(Emitter emit,List<Country> countries) async {
     try {
      final locale = await http.get(Uri.parse('http://ip-api.com/json'));
      if (locale.statusCode == 200) {
        final currentCountry =
            json.decode(locale.body)['countryCode'].toString();
       return countries.firstWhere((dynamic country) =>
            country.CountryCodeString.contains(currentCountry));
      } else {
        emit(ShowErrorAlertState(erorrMsg: 'Erorr ${locale.statusCode}'));
      }
    } on SocketException catch (_) {
      emit(ShowErrorAlertState(erorrMsg: 'No internet'));
    }
    throw{};
  }

  bool _validEmail(String email) {
    final regex = RegExp(
        r"[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z0-9][a-zA-Z0-9]*$");
    if (email.isEmpty || !regex.hasMatch(email)) {
      return false;
    }
    return true;
  }

  bool _validNumber(String phoneNumber) {
    if (phoneNumber.isNotEmpty) {
      return true;
    }
    return false;
  }
}
