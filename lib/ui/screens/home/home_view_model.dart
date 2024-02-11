import 'package:flutter/material.dart';
import 'package:password_manage_app/core/core.dart';
import 'package:password_manage_app/ui/base/base.dart';

class HomeViewModel extends BaseViewModel {
  final CategoryUseCase sqlCategoryUsecase;
  final AccountUseCase sqlAccountUsecase;
  DataShared get dataShared => DataShared.instance;
  final TextEditingController txtCategoryName = TextEditingController();

  final ValueNotifier<CategoryModel> categorySelected = ValueNotifier(
    CategoryModel(id: "-1", name: Strings.all),
  );

  bool isAccountEmpty = true;

  HomeViewModel(
      {required this.sqlCategoryUsecase, required this.sqlAccountUsecase});

  void init() async {
    dataShared.getCategories();
    dataShared.getAccounts();
    isAccountEmpty = dataShared.accountList.value.isEmpty;
  }

  void handleFilterByCategory(CategoryModel category) {
    categorySelected.value = category;
    if (categorySelected.value.id == "-1") {
      isAccountEmpty = dataShared.accountList.value.isEmpty;
      dataShared.categoryList.value = dataShared.categoryListForFilterBar.value;
    } else {
      dataShared.categoryList.value = dataShared.categoryListForFilterBar.value
          .where((element) => element.id == categorySelected.value.id)
          .toList();
      isAccountEmpty = dataShared.categoryList.value.first.accounts!.isEmpty;
    }
    setState(ViewState.busy);
  }

  void handleDeleteAccount({
    required BuildContext context,
    required AccountModel accountModel,
  }) async {
    Result<bool, Exception> result =
        await sqlAccountUsecase.deleteAccount(accountModel);
    if (result.isSuccess) {
      dataShared.getAccounts();
      dataShared.getCategories();

      Future.delayed(const Duration(milliseconds: 100), () {
        handleFilterByCategory(categorySelected.value);
      });

      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } else {
      logError(result.error);
    }
  }

  void handleCreateCategory({
    required BuildContext context,
  }) async {
    if (txtCategoryName.text.isEmpty) {
      return;
    }

    CategoryModel categoryModel = CategoryModel(name: txtCategoryName.text);

    Result<bool, Exception> result =
        await sqlCategoryUsecase.saveCategory(categoryModel);

    if (result.isSuccess) {
      dataShared.getCategories();
      txtCategoryName.clear();
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } else {
      logError(result.error);
    }
  }

  void logError(Exception? error) {
    customLogger(msg: "$error", typeLogger: TypeLogger.error);
  }
}
