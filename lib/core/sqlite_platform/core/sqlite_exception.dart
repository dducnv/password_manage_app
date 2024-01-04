class SqliteException implements Exception {
  String? message;

  SqliteException({this.message});

  @override
  String toString() {
    return message ?? "SqliteException";
  }
}
