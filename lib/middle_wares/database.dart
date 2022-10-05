import 'dart:async';
import 'package:snapchat/components/models/user.dart';
import 'package:sqflite/sqflite.dart';

abstract class DataBase {
  static Database? _usersdb;
  static int get _version => 1;

  static Future<void> init() async {
    try {
      if (_usersdb != null) {
        return;
      }
      final _path = await getDatabasesPath() + 'users.db';
      _usersdb =
          await openDatabase(_path, version: _version, onCreate: onCreate);
    } catch (_) {}
  }

  static Future<User> getUser(String username) async {
    final user = await _usersdb!
        .query('users', where: 'username = ?', whereArgs: [username]);
      /*   if(user.isEmpty){
       break;
        } */
    return /* user.isNotEmpty ? */ User.fromMap(user.first); /* : Null;  */
  }

  static Future<void> onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE users (userName STRING PRIMARY KEY NOT NULL, name STRING,lastName STRING, emailOrPhoneNumber STRING,password STRING,dateOfBirthday STRING)');
  }

  static Future<int> insert(User user) async {
   return await _usersdb!.insert('users', user.toMap());
  }
}
