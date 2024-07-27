import 'dart:io';

import 'package:bejo_app/user.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    // if _database is null, initialize it
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "users.db");

    // Get the path to the database file
    // String path = join(await getDatabasesPath(), 'users.db');

    // Check if the database already exists
    bool dbExists = await databaseExists(path);

    if (!dbExists) {
      // If not, copy the database from the assets
      ByteData data = await rootBundle.load("databases/users.db");
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write the bytes to the app's directory
      await File(path).writeAsBytes(bytes, flush: true);
    }

    // Open or create the database at the specified path
    return await openDatabase(path, version: 1);
  }

  Future<void> insertUser(User user) async {
    final Database db = await database;

    await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<User>> getUsers() async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query('users');

    return List.generate(maps.length, (i) {
      return User(
        id: maps[i]['id'],
        email: maps[i]['email'],
        firstname: maps[i]['firstname'],
        lastname: maps[i]['lastname'],
        universitas: maps[i]['universitas'],
        alamat: maps[i]['alamat'],
        password: maps[i]['password'],
      );
    });
  }

  Future<User> getUserById(int id) async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      columns: [
        'id',
        'email',
        'firstname',
        'lastname',
        'universitas',
        'alamat',
        'password',
      ],
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return User(
        id: maps.first['id'],
        email: maps.first['email'],
        firstname: maps.first['firstname'],
        lastname: maps.first['lastname'],
        universitas: maps.first['universitas'],
        alamat: maps.first['alamat'],
        password: maps.first['password'],
      );
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<void> updateUser(User user) async {
    final Database db = await database;

    await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<void> deleteUser(int id) async {
    final Database db = await database;

    await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
