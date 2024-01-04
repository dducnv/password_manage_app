import 'package:password_manage_app/core/core.dart';

abstract class AccountUseCase {
  Future<Result<List<AccountModel>, Exception>> getAccounts();
  Future<Result<AccountModel, Exception>> getAccount(
    String uid,
  );
  Future<Result<bool, Exception>> saveAccount(AccountModel account);
  Future<Result<bool, Exception>> deleteAccount(AccountModel account);
}
