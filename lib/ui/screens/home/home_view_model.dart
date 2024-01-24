import 'package:flutter/material.dart';
import 'package:password_manage_app/core/core.dart';
import 'package:password_manage_app/ui/base/base.dart';

class HomeViewModel extends BaseViewModel {
  final CategoryUseCase sqlCategoryUsecase;
  DataShared get dataShared => DataShared.instance;
  final TextEditingController txtCategoryName = TextEditingController();

  final ValueNotifier<CategoryModel> categorySelected = ValueNotifier(
    CategoryModel(id: "-1", name: "All"),
  );

  bool isAccountEmpty = true;

  HomeViewModel({required this.sqlCategoryUsecase});

  void init() async {
    dataShared.getCategories();
    dataShared.getAccounts();
    isAccountEmpty = dataShared.accountList.value.isEmpty;
  }

  void handleFilterByCategory(CategoryModel category) {
    categorySelected.value = category;
    if (categorySelected.value.id == "-1") {
      dataShared.categoryList.value = dataShared.categoryListForFilterBar.value
          .where((element) => element.id != "-1")
          .toList();
    } else {
      dataShared.categoryList.value = dataShared.categoryListForFilterBar.value
          .where((element) => element.id == categorySelected.value.id)
          .toList();
      isAccountEmpty = dataShared.categoryList.value.first.accounts!.isEmpty;
    }
    setState(ViewState.busy);
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
