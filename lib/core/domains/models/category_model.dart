import 'package:password_manage_app/core/core.dart';
import 'package:uuid/uuid.dart';

class CategoryModel extends SqliteTable implements Comparable {
  final String? id;
  final String? name;
  List<AccountModel>? accounts = [];

  AccountModel? account;

  CategoryModel({this.id, this.name, this.accounts, this.account});

  factory CategoryModel.fromJson(Map<String, dynamic> json,
      {bool isFromSql = false}) {
    if (isFromSql) {
      return CategoryModel(
        id: json['cate_uid'] != null ? tryCast(json['cate_uid']) : null,
        name: json['cate_name'] != null ? tryCast(json['cate_name']) : null,
        accounts: json['acc_uid'] != null ? [] : null,
        account: json['acc_uid'] != null
            ? AccountModel.fromJsonAndDecode(json, isFromSql: true)
            : null,
      );
    }
    return CategoryModel(
      name: json['cate_name'],
      accounts: json['accounts'] != null
          ? (json['accounts'] as List)
              .map((e) => AccountModel.fromJsonAndDecode(e, isFromSql: true))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cate_uid': id,
      'cate_name': name,
      'accounts': accounts?.map((e) => e.toJson()).toList(),
    };
  }

  @override
  int compareTo(other) {
    throw UnimplementedError();
  }

  @override
  String get createTableCommand =>
      "CREATE TABLE $tableName(cate_uid TEXT PRIMARY KEY, cate_name TEXT)";

  @override
  String get tableName => "table_categories";

  @override
  Map<String, dynamic> toMap() {
    return {
      'cate_uid': uid,
      'cate_name': name,
    };
  }

  @override
  String get uid => const Uuid().v4();
}
