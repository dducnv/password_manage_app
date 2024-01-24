import 'package:password_manage_app/core/core.dart';

class SqlUsecaseProvider implements UsecaseProvider {
  final SqliteStack sqliteStack = SqliteStack.instance;

  @override
  AccountUseCase getAccountUseCase() {
    return SqlAccountUsecase(
        repository: SqliteRepository<AccountModel>(db: sqliteStack.db));
  }

  @override
  CategoryUseCase getCategoryUseCase() {
    return SqlCategoryUsecase(
        repository: SqliteRepository<CategoryModel>(db: sqliteStack.db));
  }
}
