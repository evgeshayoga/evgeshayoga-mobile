//import 'dart:async';
//import 'package:evgeshayoga/models/user.dart';
//import 'package:path/path.dart';
//import 'package:sqflite/sqflite.dart';
//import 'dart:io';
//
//class DatabaseHelper {
//  DatabaseHelper.internal();
//
//  static final DatabaseHelper _instance = new DatabaseHelper.internal();
//
//  factory DatabaseHelper() => _instance;
//  final String tableName = "usersTable";
//  final String columnId = "id";
//  final String columnUserName = "username";
//  final String columnFamilyName = "family_name";
//  final String columnUserEmail = "user_email";
//  final String columnUserPassword = "password";
//  final String columnDateCreated = "date_created";
//
//  static Database _db;
//
//  Future<Database> get db async {
//    if (_db != null) {
//      return _db;
//    }
//    _db = await initDb();
//    return _db;
//  }
////DatabaseHelper.internal();
//  initDb() async {
//    Directory documentDirectory = await getApplicationDocumentsDirectory();
//    String path = join(documentDirectory.path, "users_table.db");
//
//    var ourDb = await openDatabase(path, version: 2, onCreate: _onCreate, onUpgrade: _onUpgrade);
//    return ourDb;
//  }
//
//  void _onUpgrade(Database db, int oldVersion, int newVersion) async {
//    if (oldVersion == 1 && newVersion == 2) {
//      await db.execute("DROP TABLE IF EXISTS $tableName");
//      _onCreate(db, newVersion);
//    }
//  }
//
//  void _onCreate(Database db, int version) async {
//    await db.execute(
//        "CREATE TABLE $tableName($columnId INTEGER PRIMARY KEY, $columnUserEmail TEXT, $columnUserName TEXT, $columnFamilyName TEXT, $columnUserPassword TEXT, $columnDateCreated TEXT)");
//  }
//
//  // Save user
//  Future<int> saveUser(User user) async {
//    var dbClient = await db;
//    int res = await dbClient.insert(tableName, user.toMap());
//    return res;
//  }
//
//  //Get users
//  Future<List> getUsers() async {
//    var dbClient = await db;
//    var result = await dbClient.rawQuery("SELECT * FROM $tableName ORDER BY $columnUserEmail ASC");
//    return result.toList();
//  }
//
//  //Count users
//  Future<int> getCount() async {
//    var dbClient = await db;
//    return Sqflite.firstIntValue(
//        await dbClient.rawQuery("SELECT COUNT(*) FROM $tableName"));
//  }
//
////Get one user
//  Future<User> getUser(String userEmail) async {
//    var dbClient = await db;
//    var result = await dbClient
//        .rawQuery("SELECT * FROM $tableName WHERE $columnUserEmail = \"$userEmail\"");
//    if (result.length == 0) {
//      return null;
//    }
//    return new User.fromMap(result.first);
//  }
//
////Delete user
//  Future<int> deleteUser(int id) async {
//    var dbClient = await db;
//    return await dbClient
//        .delete(tableName, where: "$columnId =?", whereArgs: [id]);
//  }
//
//  //Update
//  Future<int> updateItem(User user) async {
//    var dbClient = await db;
//    return await dbClient.update(tableName, user.toMap(),
//        where: "$columnId = ?", whereArgs: [user.userId]);
//  }
//  Future close() async {
//    var  dbClient = await db;
//    return dbClient.close();
//  }
//}
