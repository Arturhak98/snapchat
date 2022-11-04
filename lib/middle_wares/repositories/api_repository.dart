import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:snapchat/components/models/countries.dart';
import 'package:snapchat/components/models/country_code.dart';
import 'package:snapchat/components/models/user.dart';
import 'package:snapchat/middle_wares/repositories/token_repository.dart';

class ApiRepository {
  final _baseUrl = 'http://34.226.192.109:3000';
  final TokenRepository _tokenRepository = TokenRepository();
  Future<User?> upDateUser() async {
    final token = await _tokenRepository.getToken('token');
    final response = await http.get(Uri.parse('$_baseUrl/me'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'token': token.toString(),
        });
    if (response.statusCode == 200) {
      final user = await jsonDecode(response.body)['user'];
      if (user == null) {
        return null;
      } else {
        return User.fromMap(user);
      }
    } else {
      final error = await jsonDecode(response.body)['error'];
      throw '${response.statusCode} $error';
    }
  }

  Future<void> addUser(User user) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/addUser'),
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
      _tokenRepository.setToken(
          'token', jsonDecode(response.body)['createdTokenForUser']);
    } else {
      final error = await jsonDecode(response.body)['error'];
      throw '${response.statusCode} $error';
    }
  }

  Future<void> deleteUser() async {
    final token = await _tokenRepository.getToken('token');
    final response = await http.delete(
        Uri.parse('$_baseUrl/delete/user'),
        headers: <String, String>{'token': token.toString()});
    if (response.statusCode == 200) {
      _tokenRepository.removeToken('token');
    } else {
      final error = await jsonDecode(response.body)['error'];
      throw '${response.statusCode} $error';
    }
    _tokenRepository.removeToken('token');
  }

  Future<void> editUser(User? user) async {
    final response;
    final token = await _tokenRepository.getToken('token');
    response = await http.post(
      Uri.parse('$_baseUrl/editAccount'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'token': token.toString(),
      },
      body: jsonEncode(<String, String>{
        'lastName': user!.lastName,
        'firstName': user.name,
        'password': user.password,
        'email': user.email,
        'phone': user.phone,
        'name': user.userName,
        'birthDate': user.dateOfBirthday.toString(),
      }),
    );
    final error = await jsonDecode(response.body)['error'];
    if (response.statusCode != 200) {
      throw '${response.statusCode} $error';
    }
  }

  Future<User> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/signIn'),
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
      await _tokenRepository.setToken('token', jsonUser['createdTokenForUser']);
      final user = User.fromMap(jsonUser['user']);
      return user;
    } else {
      final error = await jsonDecode(response.body)['error'];
      throw '${response.statusCode} $error';
    }
  }

  Future<void> checkEmail(String email) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/check/email'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        (<String, String>{
          'email': email,
        }),
      ),
    );
    if (response.statusCode != 200) {
      final error = await jsonDecode(response.body)['error'];
      throw '${response.statusCode} $error';
    }
  }

  Future<void> checkUserName(String username) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/check/name'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        (<String, String>{
          'name': username,
        }),
      ),
    );
    if (response.statusCode != 200) {
      final error = await jsonDecode(response.body)['error'];
      throw '${response.statusCode} $error';
    }
  }

  Future<void> checkPhone(String phone) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/check/phone'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        (<String, String>{
          'phone': phone,
        }),
      ),
    );
    if (response.statusCode != 200) {
      final error = await jsonDecode(response.body)['error'];
      throw '${response.statusCode} $error';
    }
  }

  Future<Country> selectUserCountry(List<Country> countries) async {
    final locale = await http.get(Uri.parse('http://ip-api.com/json'));
    if (locale.statusCode == 200) {
      final currentCountry = json.decode(locale.body)['countryCode'].toString();
      return countries.firstWhere((dynamic country) =>
          country.CountryCodeString.contains(currentCountry));
    } else {
      throw 'Erorr ${locale.statusCode}';
    }
  }

  Future<List<Country>> loadJsonData() async {
    final jsonText = await http
        .get(Uri.parse('https://parentstree-server.herokuapp.com/countries'));
    if (jsonText.statusCode == 200) {
      final data = json.decode(jsonText.body) as Map<String, dynamic>;
      final countries = Countries.fromJson(data);
      return countries.countries;
    } else {
      throw 'Erorr ${jsonText.statusCode}';
    }
  }
}
