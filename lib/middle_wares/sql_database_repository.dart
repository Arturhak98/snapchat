import 'package:snapchat/components/models/country_code.dart';
import 'package:snapchat/components/models/user.dart';
import 'package:snapchat/middle_wares/countriesdatabase.dart';
import 'package:snapchat/middle_wares/usersdatabase.dart';

class SqlDatabaseRepository {
  final userdb = UsersDataBase();
  final countiesdb = CountriesDataBase();

  Future<User?> getUser(String username, String password) async {
    await userdb.init();
    final user = await userdb.usersdb!.query('usersdb',
        where: 'password = ? AND userName = ?',
        whereArgs: [password, username]);
    if (user.isEmpty) {
      return null;
    } else {
      return User.fromMap(user.first);
    }
  }

  Future<bool> getUserName(String username) async {
    await userdb.init();
    final users = await userdb.usersdb!
        .query('usersdb', where: 'userName = ?', whereArgs: [username]);
    if (users.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<int> insert(User user) async {
    await userdb.init();
    return await userdb.usersdb!.insert('usersdb', user.toMap());
  }

  Future<List<Country>> getCountries(String query) async {
    await countiesdb.init();
    final countriesMap = await countiesdb.countriesdb!.rawQuery(
      "SELECT * FROM countriesdb WHERE CountryName LIKE '%$query%' OR CountryCodeString LIKE '%$query%' OR CountryCode LIKE '%$query%'",
    );
    final countries = <Country>[];
    countriesMap.forEach((countryMap) {
      final country = Country.fromMap(countryMap);
      countries.add(country);
    });
    return countries;
  }
}
