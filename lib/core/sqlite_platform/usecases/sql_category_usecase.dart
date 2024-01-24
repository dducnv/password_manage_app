import 'package:password_manage_app/core/core.dart';

class SqlCategoryUsecase implements CategoryUseCase {
  SqliteRepository<CategoryModel> repository;
  SqlCategoryUsecase({required this.repository});

  @override
  Future<Result<bool, Exception>> deleteCategory(CategoryModel category) {
    // TODO: implement deleteCategory
    throw UnimplementedError();
  }

  @override
  Future<Result<List<CategoryModel>, Exception>> getCategories() async {
    Result<List<CategoryModel>, Exception> result = await repository.get(
        CategoryModel().tableName,
        (json) => CategoryModel.fromJson(json, isFromSql: true));
    try {
      return result;
    } catch (e) {
      return Result(error: Exception("Get category error"));
    }
  }

  @override
  Future<Result<bool, Exception>> saveCategory(CategoryModel category) {
    return repository.insert(category);
  }

  @override
  Future<Result<CategoryModel, Exception>> getCategory(String uid) {
    // TODO: implement getCategory
    throw UnimplementedError();
  }

  @override
  Future<Result<List<CategoryModel>, Exception>>
      getCategoriesWithAccounts() async {
    try {
      Result<List<CategoryModel>, Exception> resultRawQuery =
          await repository.getWithRawQuery(
        '''
            SELECT ${CategoryModel().tableName}.*, ${AccountModel().tableName}.* 
            FROM ${CategoryModel().tableName} 
            LEFT JOIN ${AccountModel().tableName} 
            ON ${CategoryModel().tableName}.cate_uid = ${AccountModel().tableName}.cate_id
          ''',
        (json) {
          customLogger(msg: "Cate W Acc: $json", typeLogger: TypeLogger.info);
          return CategoryModel.fromJson(json, isFromSql: true);
        },
      );
      Map<String, CategoryModel> categoryMap = {};
      for (CategoryModel category in resultRawQuery.data ?? []) {
        final categoryId = category.id ?? "";
        if (!categoryMap.containsKey(categoryId)) {
          categoryMap[categoryId] = category;
        }

        final account = category.account ?? AccountModel();
        print("Account: ${account.toJson()}");
        if (account.id != null &&
            account.id!.isNotEmpty &&
            account.category?.id == categoryId) {
          categoryMap[categoryId]!.accounts?.add(account);
        } else {
          categoryMap[categoryId]!.accounts = [];
        }
      }
      List<CategoryModel> categoriesWithAccounts = categoryMap.values.toList();
      return Result(data: categoriesWithAccounts);
    } catch (e) {
      return Result(error: Exception("Get categories with accounts error"));
    }
  }
}
