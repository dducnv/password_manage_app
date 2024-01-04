import 'package:password_manage_app/core/core.dart';

abstract class CategoryUseCase {
  Future<Result<List<CategoryModel>, Exception>> getCategories();
  Future<Result<List<CategoryModel>, Exception>> getCategoriesWithAccounts();
  Future<Result<CategoryModel, Exception>> getCategory(String uid);
  Future<Result<bool, Exception>> saveCategory(CategoryModel category);
  Future<Result<bool, Exception>> deleteCategory(CategoryModel category);
}
