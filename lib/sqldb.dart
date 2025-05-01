import 'dart:developer';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Sqldb {
  static Database? _db;

  Future<Database?> get db async {
    if (_db == null) {
      _db = await intialDb();
      return _db;
    } else {
      return _db;
    }
  }

  intialDb() async {
    String databasepath = await getDatabasesPath();
    String path = join(databasepath, 'abdo.db');

    Database mydb = await openDatabase(path,
        version: 2, onCreate: _onCreate, onUpgrade: _onUpgrade);
    return mydb;
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
 CREATE TABLE 'notes'
  (
   "id" INTEGER PRIMARY KEY AUTOINCREMENT,
   "note" TEXT NOT NULL,
   "title" TEXT,
   "brief" TEXT
  )
''');
    log('create database');
  }

  _onUpgrade(Database db, int oldversion, int newversion) async {
    List<Map> columns = await db.rawQuery('PRAGMA table_info(notes)');
    List<String> existingColumns =
        columns.map((col) => col['name'] as String).toList();

    if (!existingColumns.contains('title')) {
      await db.execute('ALTER TABLE notes ADD COLUMN title TEXT');
    }

    if (!existingColumns.contains('brief')) {
      await db.execute('ALTER TABLE notes ADD COLUMN brief TEXT');
    }

    log('upgrade database done');
  }

  readData(String sql) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.rawQuery(sql);
    return response;
  }

  insertData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawInsert(sql);
    return response;
  }

  updateData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawUpdate(sql);
    return response;
  }

  deleteData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawDelete(sql);
    return response;
  }
}

myDeleteDataBase() async {
  String databasepath = await getDatabasesPath();
  String path = join(databasepath, 'abdo.db');
  await deleteDatabase(path);
}
