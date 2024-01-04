import 'package:password_manage_app/core/core.dart';

class SqlAccountUsecase implements AccountUseCase {
  SqliteRepository<AccountModel> repository;

  SqlAccountUsecase({required this.repository});

  @override
  Future<Result<bool, Exception>> deleteAccount(AccountModel account) {
    return repository.delete(account);
  }

  @override
  Future<Result<AccountModel, Exception>> getAccount(String uid) async {
    try {
      final resultRawQuery = await repository.getWithRawQuery(
        '''
        SELECT ${AccountModel().tableName}.*, ${CategoryModel().tableName}.cate_name
        FROM ${AccountModel().tableName}
        LEFT JOIN ${CategoryModel().tableName} ON ${AccountModel().tableName}.cate_id = ${CategoryModel().tableName}.cate_uid
        WHERE ${AccountModel().tableName}.acc_uid = '$uid'
        ''',
        (json) {
          print(json.toString());
          return AccountModel.fromJson(json, isFromSql: true);
        },
      );

      return Result(
        data: resultRawQuery.data?.isNotEmpty == true
            ? resultRawQuery.data?.first
            : null,
      );
    } catch (e) {
      return Result(error: Exception("Get account error: $e"));
    }
  }

  @override
  Future<Result<List<AccountModel>, Exception>> getAccounts() async {
    try {
      final resultRawQuery = await repository.getWithRawQuery(
        '''
        SELECT ${AccountModel().tableName}.*, ${CategoryModel().tableName}.*
        FROM ${AccountModel().tableName}
        LEFT JOIN ${CategoryModel().tableName} ON ${AccountModel().tableName}.cate_id = ${CategoryModel().tableName}.cate_uid
        ''',
        (json) => AccountModel.fromJson(json, isFromSql: true),
      );

      return resultRawQuery;
    } catch (e) {
      return Result(error: Exception("Get accounts error: $e"));
    }
  }

  @override
  Future<Result<bool, Exception>> saveAccount(AccountModel account) {
    return repository.insert(account);
  }
}
