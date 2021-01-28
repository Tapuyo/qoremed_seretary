import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper1 {

  static final _databaseName = "myNewDbnxt.db";
  static final _databaseVersion = 1;

  static final table = 'my_tablenxt';

  static final columnId = '_id';
  static final nxtdt = 'nxtdt';
  static final nxtdoc = 'nxtdoc';
  static final nxttime = 'nxttime';
  static final nxtdocimg = 'nxtdocimg';
  static final nxtid = 'nxtid';
  static final nxthospital = 'nxthospital';
  static final nxtdocsp = 'nxtdocsp';
  static final nxtname = 'nxtname';
  static final nxtstatus = 'nxtstatus';
  static final nxtref = 'nxtref';
  static final que = 'que';
  static final consult = 'consult';
  static final starttime = 'starttime';




  // make this a singleton class
  DatabaseHelper1._privateConstructor();
  static final DatabaseHelper1 instance = DatabaseHelper1._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $nxtdt TEXT NOT NULL,
            $nxtdoc TEXT NOT NULL,
            $nxttime TEXT NOT NULL,
            $nxtdocimg TEXT NOT NULL,
            $nxtid TEXT NOT NULL,
            $nxthospital TEXT NOT NULL,
            $nxtdocsp TEXT NOT NULL,
            $nxtname TEXT NOT NULL,
            $nxtstatus TEXT NOT NULL,
            $nxtref TEXT NOT NULL,
            $que TEXT NOT NULL,
            $consult TEXT NOT NULL,
            $starttime TEXT NOT NULL
          )
          ''');
  }


  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }


  Future<int> queryRowCount() async {
    Database db = await instance.database;
    return  Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $table'));

  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db.update(table, row, where: '$columnId = 1');
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table);
  }
}