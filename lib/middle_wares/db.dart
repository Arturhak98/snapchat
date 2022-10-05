// ignore_for_file: avoid_print

import 'dart:async';
import 'package:sqflite/sqflite.dart';

import '../components/models/model.dart';

abstract class DB {
  static Database? _db;

  static int get _version => 2;
  static Future<void> init() async {
    if (_db != null) {
      return;
    }
    final _path = 'data/dartur.db';
    _db = await openDatabase(_path, version: _version, onCreate: onCreate);
    print(_db);
    /*  await insert(
        'users', Model(id: 2, username: 'artur', password: 'hakobyan'));  */
        final model=await getClient('artur');
    print(model);
  }
  static getClient(String id) async {
   // final db = await database;
   final res   =await  _db!.query('users', where: 'username = ?', whereArgs: [id]);
    return res.isNotEmpty ? Model.fromMap(res.first) : Null ;
  }

  static Future<void> onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE users (id INTEGER PRIMARY KEY NOT NULL, username STRING, password STRING)');
  }

  static Future<List<Map<String, dynamic>>> query(String table) async {
    return
    _db!.query(table);
  }

  static Future<int> insert(String table, Model model) async =>
      await _db!.insert(table, model.toMap());

  /* static Future<int> update(String table, Model model) async =>
        await _db!.update(table, model.toMap(), where: 'id = ?', whereArgs: [model.id]);

    static Future<int> delete(String table, Model model) async =>
        await _db!.delete(table, where: 'id = ?', whereArgs: [model.id]); */
}
