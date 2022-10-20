import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
//import 'package:intl/intl_standalone.dart';
import 'package:snapchat/components/models/countries.dart';
import 'package:snapchat/components/models/country_code.dart';
import 'package:snapchat/components/models/user.dart';

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

  Future<void> addUser(User user) async {
    /*  final response =  */ await http.post(
      Uri.parse('https://parentstree-server.herokuapp.com/addUser'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'lastName': user.lastName,
        'firstName': user.name,
        'password': user.password,
        'email': user.email,
        'phone': user.phone,
        'name': user.userName,
        'birthDate': user.dateOfBirthday.toString(),
      }),
    );
  }

  Future<User?> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('https://parentstree-server.herokuapp.com/signIn'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{
          'login': username,
          'password': password,
        },
      ),
    );
    final jsonUser = jsonDecode(response.body);
    if (jsonUser['error'] == null) {
      return User.fromMap(jsonUser['user']);
    }
    return null;
  }

  Future<bool> checkConnection() async {
    final response = await http.get(
        Uri.parse('https://parentstree-server.herokuapp.com/checkConnection'));
    if (jsonDecode(response.body)['error'] == null) {
      return false;
    }
    return true;
  }

  Future<bool> checkEmail(String email) async {
    final response = await http.post(
      Uri.parse('https://parentstree-server.herokuapp.com/check/email'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        (<String, String>{
          'email': email,
        }),
      ),
    );
    if (jsonDecode(response.body)['error'] == null) {
      return true;
    }
    return false;
  }

  Future<bool> checkUserName(String username) async {
    final response = await http.post(
      Uri.parse('https://parentstree-server.herokuapp.com/check/name'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        (<String, String>{
          'name': username,
        }),
      ),
    );
    if (jsonDecode(response.body)['error'] == null) {
      return true;
    }
    return false;
  }

  Future<bool> checkPhone(String phone) async {
    final response = await http.post(
      Uri.parse('https://parentstree-server.herokuapp.com/check/phone'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        (<String, String>{
          'phone': phone,
        }),
      ),
    );
    if (jsonDecode(response.body)['error'] == null) {
      return true;
    }
    return false;
  }

/*   Future<void> validate(String username, String password) async {
    final response = await http.post(
        Uri.parse('https://parentstree-server.herokuapp.com/check/email'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{'email': 'yuim.m'}));

    if (jsonDecode(response.body)['error'] == null) {
      print(response);
    } */
/*   }*/
}
