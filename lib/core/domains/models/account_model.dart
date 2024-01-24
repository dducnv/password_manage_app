import 'dart:convert';
import 'package:uuid/uuid.dart';

import 'package:password_manage_app/core/core.dart';

class AccountModel extends SqliteTable implements Comparable {
  final String? id;
  String? title;
  String? email;
  String? password;
  String? note;
  List<Map<String, dynamic>>? customFields;
  String? icon;
  CategoryModel? category;

  AccountModel({
    this.id,
    this.title,
    this.email,
    this.icon,
    this.category,
    this.password,
    this.note,
    this.customFields,
  });

  factory AccountModel.fromJsonAndDecode(
    Map<String, dynamic> json, {
    bool isFromSql = false,
  }) {
    return AccountModel(
      id: tryCast(json['acc_uid']),
      title: decodeInfo(tryCast(json['acc_title'])),
      email: decodeInfo(tryCast(json['acc_email'])),
      icon: tryCast(json['acc_icon']),
      password: tryCast(json['acc_password']),
      note: json['acc_note'] != "" ? decodeInfo(tryCast(json['acc_note'])) : "",
      customFields: json['acc_custom_fields'] != null
          ? (jsonDecode(tryCast(json['acc_custom_fields'])) as List)
              .map((e) => e as Map<String, dynamic>)
              .toList()
          : [],
      category: json['cate_id'] != null && json['cate_name'] != null
          ? CategoryModel(
              id: tryCast(json['cate_id']),
              name: tryCast(json['cate_name']),
              accounts: [],
            )
          : null,
    );
  }

  factory AccountModel.fromJson(
    Map<String, dynamic> json, {
    bool isFromSql = false,
  }) {
    if (isFromSql) {
      return AccountModel(
        id: tryCast(json['acc_uid']),
        icon: tryCast(json['acc_icon']),
        title: tryCast(json['acc_title']),
        email: tryCast(json['acc_email']),
        password: tryCast(json['acc_password']),
        note: tryCast(json['acc_note']),
        customFields: json['acc_custom_fields'] != null
            ? (jsonDecode(tryCast(json['acc_custom_fields'])) as List)
                .map((e) => e as Map<String, dynamic>)
                .toList()
            : [],
        category: json['cate_id'] != null && json['cate_name'] != null
            ? CategoryModel(
                id: tryCast(json['cate_id']),
                name: tryCast(json['cate_name']),
                accounts: [],
              )
            : null,
      );
    }

    return AccountModel(
      id: tryCast(json['acc_uid']),
      title: tryCast(json['acc_title']),
      email: tryCast(json['acc_email']),
      icon: tryCast(json['acc_icon']),
      password: tryCast(json['acc_password']),
      note: tryCast(json['acc_note']),
      customFields: json['acc_custom_fields'] != null
          ? (jsonDecode(tryCast(json['acc_custom_fields'])) as List)
              .map((e) => e as Map<String, dynamic>)
              .toList()
          : [],
      category: json['cate_id'] != null && json['cate_name'] != null
          ? CategoryModel(
              id: tryCast(json['cate_id']),
              name: tryCast(json['cate_name']),
              accounts: [],
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'acc_uid': id ?? '',
      'acc_icon': icon ?? '',
      'acc_title': title ?? '',
      'acc_email': email ?? '',
      'acc_password': password ?? '',
      'acc_note': note ?? '',
      'acc_custom_fields':
          customFields != null ? jsonEncode(customFields) : null,
      'cate_id': category?.id ?? '',
    };
  }

  @override
  int compareTo(other) {
    throw UnimplementedError();
  }

  @override
  String get createTableCommand => '''CREATE TABLE 
      $tableName(
        acc_uid TEXT PRIMARY KEY, 
        acc_icon TEXT, 
        acc_title TEXT, 
        acc_email TEXT, 
        acc_password TEXT, 
        acc_note TEXT, 
        acc_custom_fields TEXT, 
        cate_id TEXT, 
        FOREIGN KEY(cate_id) REFERENCES CategoryModel(cate_uid) 
        ON DELETE SET NULL ON UPDATE CASCADE)
        ''';

  @override
  String get tableName => "table_accounts";

  @override
  Map<String, dynamic> toMap() {
    return {
      'acc_uid': uid,
      'acc_icon': icon ?? '',
      'acc_title': title ?? '',
      'acc_email': email ?? '',
      'acc_password': password ?? '',
      'acc_note': note ?? '',
      'acc_custom_fields':
          customFields != null ? jsonEncode(customFields) : null,
      'cate_id': category?.id ?? '',
    };
  }

  @override
  String get uid => id ?? const Uuid().v4();
}
