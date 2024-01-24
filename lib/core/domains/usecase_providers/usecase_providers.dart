import 'package:password_manage_app/core/core.dart';

abstract class UsecaseProvider {
  AccountUseCase getAccountUseCase();
  CategoryUseCase getCategoryUseCase();
}
