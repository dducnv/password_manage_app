import 'package:password_manage_app/core/core.dart';
import 'package:password_manage_app/core/utils/logger.dart';
import 'package:sqflite/sqflite.dart';

class SqliteRepository<T> {
  final Database db;

  SqliteRepository({required this.db});

  Future<Result<List<T>, Exception>> getWithRawQuery(
      String rawQuery, JsonToModelHandle<T> jsonToModelHandle) async {
    customLogger(
      msg: rawQuery,
      typeLogger: TypeLogger.info,
    );
    final List<Map<String, dynamic>> models = await db.rawQuery(rawQuery);
    return Result(data: models.map((e) => jsonToModelHandle(e)).toList());
  }

  Future<Result<List<T>, Exception>> get(
      String tableName, JsonToModelHandle<T> jsonToModelHandle,
      {bool? distinct,
      List<String>? columns,
      String? where,
      List<Object?>? whereArgs,
      String? groupBy,
      String? having,
      String? orderBy,
      int? limit,
      int? offset}) async {
    final List<Map<String, dynamic>> models = await db.query(tableName,
        distinct: distinct,
        columns: columns,
        where: where,
        whereArgs: whereArgs,
        groupBy: groupBy,
        having: having,
        orderBy: orderBy,
        limit: limit,
        offset: offset);
    return Result(data: models.map((e) => jsonToModelHandle(e)).toList());
  }

  Future<Result<bool, Exception>> save(
      T model, JsonToModelHandle<T> jsonToModelHandle) async {
    if (model is SqliteTable) {
      Result<List<T>, Exception> rst =
          await get(model.tableName, (json) => jsonToModelHandle(json));
      if (rst.isSuccess && (rst.data?.length ?? 0) > 0) {
        return update(model);
      } else {
        return insert(model);
      }
    } else {
      return Result(
          error:
              SqliteException(message: "${T.runtimeType} is not SqliteTable"));
    }
  }

  Future<Result<bool, Exception>> insert(T model) async {
    if (model is SqliteTable) {
      int row = await db.insert(model.tableName, model.toMap());
      return Result(data: row > 0);
    } else {
      return Result(
          error:
              SqliteException(message: "${T.runtimeType} is not SqliteTable"));
    }
  }

  Future<Result<bool, Exception>> update(T model) async {
    if (model is SqliteTable) {
      int row = await db.update(
        model.tableName,
        model.toMap(),
        where: 'uid = ?',
        whereArgs: [model.uid],
      );
      return Result(data: row > 0);
    } else {
      return Result(
          error:
              SqliteException(message: "${T.runtimeType} is not SqliteTable"));
    }
  }

  Future<Result<bool, Exception>> delete(T model) async {
    if (model is SqliteTable) {
      int row = await db.delete(
        model.tableName,
        where: 'uid = ?',
        whereArgs: [model.uid],
      );
      return Result(data: row > 0);
    } else {
      return Result(
          error:
              SqliteException(message: "${T.runtimeType} is not SqliteTable"));
    }
  }
}
