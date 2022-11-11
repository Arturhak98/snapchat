import 'package:flutter_mongodb_realm/database/database.dart';
import 'package:flutter_mongodb_realm/mongo_realm_client.dart';
import 'package:flutter_mongodb_realm/realm_app.dart';
import 'package:snapchat/components/models/country_code.dart';
import 'package:snapchat/components/models/user.dart';
import 'package:snapchat/middle_wares/databases/countries_database.dart';
import 'package:snapchat/middle_wares/databases/users_database.dart';
import 'package:snapchat/middle_wares/repositories/token_repository.dart';

class SqlDatabaseRepository {
  final MongoRealmClient client = MongoRealmClient();
  final RealmApp app = RealmApp();
  final userdb = UsersDataBase();
  final countriesdb = CountriesDataBase();
  Future<void> deleteUser() async {
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
    var collection = client.getDatabase('users').getCollection('user');
    print(collection);
   final a= await collection.insertOne(MongoDocument({'name':'artur1','lastname':'hakobyan'}));
    print('$collection $a');
    final size = await collection.count();
    print('size=$size');
    /*  final client = MongoRealmClient();
     final collection = client.getDatabase('users').getCollection('user');
     print(collection);
    await collection.insertOne(MongoDocument(user.toMap()));
     print(collection); */
    // app.login(Credentials.jwt(
    //     'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcHBsaWNhdGlvbi0wLXRid2FqIiwiZXhwIjoyNTE2MjM5MDIyLCJzdWIiOiI2MjgyMGM1ODZiYTEyMzBmZDM3MGZiMzIiLCJ1c2VyX2RhdGEiOnsibmFtZSI6ImEifSwiaWF0IjoxNjY3OTgyNzE1fQ.dwLg9vvGiR8yHGJrOCQGqLAfa3xGKTCioQVFVt8a7PxQax_s4rjlNalTQ-SSd-CkqtR9Ly3t8Zj8zOV4JjP-t6hDVNg-_yrnmpeZRQbVbU6PdqTeCPTiISI2U56EzeG406o7-IstMVMQAqv18a37YyDMDhZZiyN4kIGHtKjMz0uDC4U9v-dqwLLR3Whs3cjBScdtMCyXoHSMFElJLQWCPJbLnfFvYXbATYnVbUO-KWqj4RUG8aE-2OB_btwTO-2Vr6SJ4ycOan8NYqQ2Mt8bxF13wjtAsmAWuIw7wYVt8J5IggcPTZRdrU7aKxaS8uTvanmFjpb5x3rWX0QrzzkG9GcelBQhwapHr2KijO8N4bzTraKCJjMWaNT2scHVxPbFVD3S_zFRsZqUQkmka-NrDe5j6N-B0v4-NYTcRVAJLIAtTvUhpeS6I61BaHTr2LL3Lz_AlxJfQEl82rs7DMqf6bwYyCWRhqmonNUYFKYUU2534P5RkB-s1n81AT3OeWjL_f2aalaEN9a-SHp356sloqb4asGAys58UJljpw_a_51ntByy1OLp2Px2d0aMLYh2M-tyYtBtNtDPYkfHHkYpf-C93SpNLLx7Wxdt33XzmHa5yNsVL99olkqqvGNp3nNHF_broQkm1V6CB6cnMbfwQb6b00_-JWnTqo_mNWUmviM'));
    // final a =await app.currentUser;
    // print(a);
    await userdb.init();
    return await userdb.usersdb!.insert('usersdb', user.toMap());
  }

  Future<void> Logout() async {
    await userdb.init();
    TokenRepository().removeToken('token');
    userdb.usersdb!.delete('usersdb');
  }

  Future<void> setCountries(List<Country> countries) async {
    await countriesdb.init();
    countries.forEach((country) {
      countriesdb.countriesdb!.insert('countriesdb', country.toMap());
    });
  }

  Future<List<Country>> getCountries({String query = ''}) async {
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
