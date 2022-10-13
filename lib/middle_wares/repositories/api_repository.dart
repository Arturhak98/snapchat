import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:snapchat/components/models/countries.dart';
import 'package:snapchat/components/models/country_code.dart';

class ApiRepository {
  Future<List<Country>> loadJsonData() async {
    try {
      final jsonText = await http
          .get(Uri.parse('https://parentstree-server.herokuapp.com/countries'));
      if (jsonText.statusCode == 200) {
        final data = json.decode(jsonText.body) as Map<String, dynamic>;
        final countries = Countries.fromJson(data);
        return countries.countries;
      } else {
        throw 'Erorr ${jsonText.statusCode}';
      }
    } catch (_) {
      throw 'No internet';
    }
  }
  Future<Country> selectUserCountry(List<Country> countries) async {
    try {
      final locale = await http.get(Uri.parse('http://ip-api.com/json'));
      if (locale.statusCode == 200) {
        final currentCountry =
            json.decode(locale.body)['countryCode'].toString();
        return countries.firstWhere((dynamic country) =>
            country.CountryCodeString.contains(currentCountry));
      } else {
        throw 'Erorr ${locale.statusCode}';
      }
    } on SocketException catch (_) {
      throw 'No internet';
    }
    
  }
}
