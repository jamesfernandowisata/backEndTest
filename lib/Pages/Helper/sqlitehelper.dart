import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class sqlitehelper {
  static final _sqliteDBName = 'sqliteDB.db';
  static final _sqliteDBVersion = 1;
  static final _sqliteTableName = 'sqliteTable';

  static final sqliteColumnId = '_sqliteColumnId';
  static final sqliteColumnName = 'name';

  sqlitehelper._privateConstructor();
  static final sqlitehelper instance = sqlitehelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initiateSQLDB();

  _initiateSQLDB() async {
    Directory directory = await getApplicationDocumentsDirectory();
    print('this is the directory $directory');
    String DBPath = join(directory.path, _sqliteDBName);
    print('this is the $DBPath');
    return await openDatabase(DBPath,
        version: _sqliteDBVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    return await db.execute('''
        CREATE TABLE $_sqliteTableName (
          $sqliteColumnId INTEGER PRIMARY KEY,
          $sqliteColumnName TEXT NOT NULL)
      ''');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(_sqliteTableName, row);
  }

  Future<List<Map<String, dynamic>>> queryAll() async {
    Database db = await instance.database;
    return await db.query(_sqliteTableName);
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[sqliteColumnId];
    return await db.update(_sqliteTableName, row,
        where: '$sqliteColumnId=?', whereArgs: [id]);
  }

  Future delete(int id) async {
    Database db = await instance.database;
    return await db
        .delete(_sqliteTableName, where: '$sqliteColumnId =?', whereArgs: [id]);
  }
}
