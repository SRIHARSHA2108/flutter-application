import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter_application_1/models/app_user.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DuplicateUserException implements Exception {
  const DuplicateUserException(this.message);

  final String message;
}

class UserDatabase {
  UserDatabase._();

  static final UserDatabase instance = UserDatabase._();
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    final path = join(await getDatabasesPath(), 'gandaberunda_users.db');
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            full_name TEXT NOT NULL,
            username TEXT NOT NULL UNIQUE COLLATE NOCASE,
            email TEXT NOT NULL UNIQUE COLLATE NOCASE,
            password_hash TEXT NOT NULL,
            phone TEXT NOT NULL DEFAULT '',
            bio TEXT NOT NULL DEFAULT ''
          )
        ''');
      },
    );
    return _database!;
  }

  String _hashPassword(String password) =>
      sha256.convert(utf8.encode(password)).toString();

  Future<AppUser> register({
    required String fullName,
    required String username,
    required String email,
    required String password,
  }) async {
    final db = await database;
    try {
      final id = await db.insert('users', {
        'full_name': fullName.trim(),
        'username': username.trim(),
        'email': email.trim().toLowerCase(),
        'password_hash': _hashPassword(password),
      });
      return AppUser(
        id: id,
        fullName: fullName.trim(),
        username: username.trim(),
        email: email.trim().toLowerCase(),
        phone: '',
        bio: '',
      );
    } on DatabaseException catch (error) {
      if (error.isUniqueConstraintError()) {
        throw const DuplicateUserException(
          'That username or email is already registered.',
        );
      }
      rethrow;
    }
  }

  Future<AppUser?> login({
    required String email,
    required String password,
  }) async {
    final db = await database;
    final rows = await db.query(
      'users',
      where: 'email = ? AND password_hash = ?',
      whereArgs: [email.trim().toLowerCase(), _hashPassword(password)],
      limit: 1,
    );
    return rows.isEmpty ? null : AppUser.fromMap(rows.first);
  }
}
