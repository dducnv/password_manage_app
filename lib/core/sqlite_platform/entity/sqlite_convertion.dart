abstract class SqliteTable {
  String get createTableCommand;
  String get tableName;
  String get uid;
  Map<String, dynamic> toMap();
}
