import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snapchat/components/models/countries.dart';
import 'package:snapchat/components/models/country_code.dart';
import 'package:snapchat/components/models/user.dart';


class ApiRepository {
  Future<User?> upDateUser() async {
    final prefs = await SharedPreferences.getInstance();
    final response = await http.get(Uri.parse('http://34.226.192.109:3000/me'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'token': prefs.getString('token').toString(),
        });
    if (response.statusCode == 200 &&
        jsonDecode(response.body)['user'] != null) {
      return User.fromMap(jsonDecode(response.body)['user']);
      /*    SqlDatabaseRepository()
            .editUser(User.fromMap(jsonDecode(response.body)['user']));
        return User.fromMap(jsonDecode(response.body)['user']);
      } else {
        SqlDatabaseRepository().Logout();
        */

    }
    prefs.remove('token');
    return null;
  }

  Future<bool> addUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final response = await http.post(
      Uri.parse('http://34.226.192.109:3000/addUser'),
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
    if (response.statusCode == 200) {
      prefs.setString(
          'token', await jsonDecode(response.body)['createdTokenForUser']);
          return true;
     // SqlDatabaseRepository().insert(user);
    }
    return false;
  }

  Future<bool> deleteUser() async {
    final prefs = await SharedPreferences.getInstance();
    final response = await http.delete(
        Uri.parse('http://34.226.192.109:3000/delete/user'),
        headers: <String, String>{
          'token': prefs.getString('token').toString()
        });
    if (response.statusCode == 200 &&
        jsonDecode(response.body)['error'] == null) {
      prefs.remove('token');
      return true;

      //  SqlDatabaseRepository().deleteUser();
    }
    prefs.remove('token');
    return false;
  }

  Future<String?> editUser(User user) async {
    final response;
    String? error;
    try {
      final prefs = await SharedPreferences.getInstance();
      response = await http.post(
        Uri.parse('http://34.226.192.109:3000/editAccount'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'token': prefs.getString('token').toString(),
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
      error= jsonDecode(response.body)['error'];
      if (response.statusCode == 200 &&
          jsonDecode(response.body)['error'] == null) {
        return null;
        //  final user = User.fromMap(jsonDecode(response.body)['user']);
        //  await SqlDatabaseRepository().editUser(user);
      }
    } catch (_) {
      throw ('error');
    }
    return error;
  }

  Future<User?> login(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final response = await http.post(
      Uri.parse('http://34.226.192.109:3000/signIn'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
        <String, String>{
          'login': username,
          'password': password,
        },
      ),
    );
    if (response.statusCode == 200) {
      final jsonUser = jsonDecode(response.body);
      if (jsonUser['error'] == null) {
        await prefs.setString('token', jsonUser['createdTokenForUser']);
        final user = User.fromMap(jsonUser['user']);
       // await SqlDatabaseRepository().insert(user);
        return user;
      }
    }
    return null;
  }

  Future<bool> checkConnection() async {
    final response =
        await http.get(Uri.parse('http://34.226.192.109:3000/checkConnection'));
    if (jsonDecode(response.body)['error'] == null) {
      return false;
    }
    return true;
  }

  Future<bool> checkEmail(String email) async {
    final response = await http.post(
      Uri.parse('http://34.226.192.109:3000/check/email'),
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
      Uri.parse('http://34.226.192.109:3000/check/name'),
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
      Uri.parse('http://34.226.192.109:3000/check/phone'),
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
}
