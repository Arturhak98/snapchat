import 'dart:async';
import 'package:sqflite/sqflite.dart';

class UsersDataBase {
  static final UsersDataBase dataBase = UsersDataBase._dataBase();
  UsersDataBase._dataBase();
  factory UsersDataBase() {
    return dataBase;
  }
  Database? usersdb;

  Future<void> init() async {
    try {
      if (usersdb != null) {
        return;
      }
      usersdb = await openDatabase(await getDatabasesPath() + 'usersdb.db',
          version: 1, onCreate: onCreate);
    } catch (_) {}
  }

  Future<void> onCreate(Database db, int version) async {
    await db.execute('CREATE TABLE usersdb'
        '(name STRING PRIMARY KEY NOT NULL,'
        'firstName STRING,lastName STRING, email STRING, phone STRING,'
        'password STRING,birthDate STRING)');
  }
}

 