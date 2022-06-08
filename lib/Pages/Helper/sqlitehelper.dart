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
    String DBPath = join(directory.path, _sqliteDBName);
    return await openDatabase(DBPath,
        version: _sqliteDBVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) {
    db.query('''
        CREATE TABLE $_sqliteTableName (
          $sqliteColumnId INTEGER PRIMARY KEY,
          $sqliteColumnName TEXT NOT NULL)
      ''');
    throw '';
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    await db.insert(_sqliteTableName, row);
    throw '';
  }
}
