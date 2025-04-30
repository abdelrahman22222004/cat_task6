import 'dart:developer';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Sqldb {
  static Database? _db;

  Future<Database?> get db async {
    // بتأكد هيا موجودة ولا لأ
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

    // open
    Database mydb = await openDatabase(path,
        version: 2, onCreate: _onCreate, onUpgrade: _onUpgrade);
    return mydb;
  }

  // calling only one for creation
  Future _onCreate(Database db, int version) async {
    // ممكن استخدم حاجة اسمها  batch بدل م اعقد  اعمل (execute )لانشاء كل جدول
    await db.execute('''
 CREATE TABLE 'notes'
  (
   "id" INTEGER PRIMARY KEY AUTOINCREMENT,
   "note" TEXT NOT NULL,
   "title" TEXT,
   "color" TEXT
  )
''');
    log('create database');
  }

  _onUpgrade(Database db, int oldversion, int newversion) async {
    // بنجيب معلومات الأعمدة الحالية
    List<Map> columns = await db.rawQuery('PRAGMA table_info(notes)');
    List<String> existingColumns =
        columns.map((col) => col['name'] as String).toList();

    // لو مفيش title نضيفها
    if (!existingColumns.contains('title')) {
      await db.execute('ALTER TABLE notes ADD COLUMN title TEXT');
    }

    // لو مفيش color نضيفها
    if (!existingColumns.contains('color')) {
      await db.execute('ALTER TABLE notes ADD COLUMN color TEXT');
    }

    log('upgrade database done');
  }

  // build an method that roles is (select)
  readData(String sql) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.rawQuery(sql);
    return response;
  }

  // build an method that roles is (insert)
  insertData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawInsert(sql);
    return response;
  }

  // build an method that roles is (update)
  updateData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawUpdate(sql);
    return response;
  }

  // build an method that roles is (delete)
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
