import 'package:shared_preferences/shared_preferences.dart';
import 'package:snapchat/components/models/country_code.dart';
import 'package:snapchat/components/models/user.dart';
import 'package:snapchat/middle_wares/databases/countriesdatabase.dart';
import 'package:snapchat/middle_wares/databases/usersdatabase.dart';

class SqlDatabaseRepository {
  final userdb = UsersDataBase();
  final countriesdb = CountriesDataBase();
  Future<void> deleteUser()async{
    await userdb.init();
    await userdb.usersdb!.delete('usersdb');
  }

  Future<void> editUser(User user) async {
    await userdb.init();
    await userdb.usersdb!.update('usersdb', user.toMap());
  }

  Future<User> getUser() async {
    await userdb.init();
    final user = await userdb.usersdb!.query('usersdb');
    return User.fromMap(user.first);
  }

  Future<int> insert(User user) async {
    await userdb.init();
    return await userdb.usersdb!.insert('usersdb', user.toMap());
  }

  Future<void> Logout() async {
    final prefs = await SharedPreferences.getInstance();
    await userdb.init();
    prefs.remove('token');
    userdb.usersdb!.delete('usersdb');
  }

  Future<List<Country>> getCountries(String query) async {
    await countriesdb.init();
    final countriesMap = await countriesdb.countriesdb!.rawQuery(
      'SELECT * FROM countriesdb'
      " WHERE Name LIKE '%$query%'"
      " OR CodeString LIKE '%$query%'"
      " OR Code LIKE '%$query%'",
    );
    final countries = <Country>[];
    countriesMap.forEach((countryMap) {
      final country = Country.fromMap(countryMap);
      countries.add(country);
    });
    return countries;
  }
}
/*   Future<bool> getUserName(String username) async {
    await userdb.init();
    final users = await userdb.usersdb!
        .query('usersdb', where: 'userName = ?', whereArgs: [username]);
    if (users.isNotEmpty) {
      return true;
    }
    return false;
  } */
/* 
  Future<User?> getUserFromToken() async {
    await userdb.init();
    final userJson = await userdb.usersdb!
        .query('usersdb', where: 'token != ?', whereArgs: ['']);
    if (userJson.isNotEmpty) {
      final user = User.fromMap(userJson.first)
        ..token = userJson.first['token'].toString();
      return user;
    }
    return null;
    //print(user);
  } */