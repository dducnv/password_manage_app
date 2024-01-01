import 'package:password_manage_app/core/domains/models/models.dart';

class CategoryModel {
  final int? id;
  final String? name;
  final String? image;
  final List<AccountModel>? accounts;

  CategoryModel({this.id, this.name, this.image, this.accounts});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      image: json['image'],
    );
  }
}
