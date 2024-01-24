import 'package:flutter/foundation.dart';
import 'package:password_manage_app/core/core.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqliteStack {
  static final SqliteStack instance = SqliteStack._internal();
  late Database db;

  SqliteStack._internal();

  Future<void> inititalDB(List<String> createTableCommands) async {
    String path = await getDatabasesPath();
    if (kDebugMode) {
      customLogger(msg: "SQLite db path: $path", typeLogger: TypeLogger.info);
    }
    db = await openDatabase(join(path, 'passwordManager.db'), version: 1,
        onCreate: (Database db, int version) async {
      for (String command in createTableCommands) {
        await db.execute(command);
      }
    });
  }
}
