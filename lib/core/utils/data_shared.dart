import 'package:flutter/material.dart';
import 'package:password_manage_app/core/core.dart';
import 'package:password_manage_app/core/service_locator/service_locator.dart';
import 'package:password_manage_app/main.dart';

class DataShared extends ChangeNotifier {
  static final instance = DataShared._internal();

  DataShared._internal();

  CategoryUseCase sqlCategoryUsecase = locator.get<CategoryUseCase>(
      instanceName: DependencyInstance.sqlCategoryUsecase.name);
  final AccountUseCase sqlAccountUsecase = locator.get<AccountUseCase>(
      instanceName: DependencyInstance.sqlAccountUsecase.name);

  final ValueNotifier<List<AccountModel>> accountList = ValueNotifier([]);

  final ValueNotifier<List<CategoryModel>> categoryList = ValueNotifier([]);
  final ValueNotifier<List<CategoryModel>> categoryListForFilterBar =
      ValueNotifier([]);

  void getCategories() {
    try {
      sqlCategoryUsecase.getCategoriesWithAccounts().then((value) {
        if (value.isSuccess) {
          setCategoryList(value.data ?? []);
        } else {
          customLogger(msg: "${value.error}", typeLogger: TypeLogger.error);
        }
      });
    } catch (e) {
      customLogger(msg: "$e", typeLogger: TypeLogger.error);
    }
  }

  void getAccounts() {
    try {
      sqlAccountUsecase.getAccounts().then((value) {
        if (value.isSuccess) {
          final accounts = value.data ?? [];
          accountList.value = [...accounts];
        } else {
          customLogger(msg: "${value.error}", typeLogger: TypeLogger.error);
        }
      });
    } catch (e) {
      customLogger(msg: "$e", typeLogger: TypeLogger.error);
    }
  }

  void setCategoryList(List<CategoryModel> list) {
    categoryList.value = list;
    categoryListForFilterBar.value = list;
    notifyListeners();
  }

  void setAccounts(List<AccountModel> list) {
    accountList.value = list;
    notifyListeners();
  }

  void addCategory(CategoryModel category) {
    categoryList.value = [...categoryList.value, category];
    notifyListeners();
  }

  void updateCategory(CategoryModel category) {
    categoryList.value = [
      ...categoryList.value
          .where((element) => element.id != category.id)
          .toList(),
      category
    ];
    notifyListeners();
  }
}
