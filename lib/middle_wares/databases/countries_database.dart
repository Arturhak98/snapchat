import 'package:sqflite/sqflite.dart';

class CountriesDataBase {
  static final CountriesDataBase countriesDataBase =
      CountriesDataBase._CountriesDataBase();
  CountriesDataBase._CountriesDataBase();
  factory CountriesDataBase() {
    return countriesDataBase;
  }
  Database? countriesdb;
  Future<void> init() async {
    try {
      if (countriesdb != null) {
        return;
      }
      countriesdb = await openDatabase(
          await getDatabasesPath() + 'countiesdb.db',
          version: 1,
          onCreate: onCreate);
    } catch (_) {}
  }

  Future<void> onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE countriesdb (CodeString STRING , Code STRING,Name STRING)');
  }
}
