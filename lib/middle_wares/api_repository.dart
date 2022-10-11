import 'dart:convert';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:snapchat/components/models/countries.dart';
import 'package:snapchat/components/models/country_code.dart';
import 'package:snapchat/screens/signup_phone_or_email/bloc/signup_phone_or_email_bloc_bloc.dart';

class ApiRepository{

  Future<List<Country>> loadJsonData(Emitter emit) async {
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

  Future<Country> selectUserCountry(Emitter emit,List<Country> countries) async {
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
}