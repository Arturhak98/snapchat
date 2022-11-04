import 'package:shared_preferences/shared_preferences.dart';

class TokenRepository {
  Future<String?> getToken(String tokenName) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(tokenName);
    return token;
  }

  Future<void> setToken(String tokenName, String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(tokenName, token);
  }

  Future<void> removeToken(String tokenName) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(tokenName);
  }
}
