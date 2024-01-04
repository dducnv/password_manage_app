import 'package:flutter/material.dart';
import 'package:password_manage_app/core/core.dart';
import 'package:password_manage_app/core/utils/logger.dart';
import 'package:password_manage_app/ui/base/base.dart';

class HomeViewModel extends BaseViewModel {
  final CategoryUseCase sqlCategoryUsecase;
  final TextEditingController txtCategoryName = TextEditingController();

  final ValueNotifier<List<CategoryModel>> listCategory = ValueNotifier([]);
  final ValueNotifier<List<CategoryModel>> listCategoryFilterBar =
      ValueNotifier([]);
  final ValueNotifier<CategoryModel?> categorySelected = ValueNotifier(
    CategoryModel(id: "-1", name: "All"),
  );

  HomeViewModel({required this.sqlCategoryUsecase});

  void init() async {
    await getCategories();
  }

  void handleFilterByCategory(CategoryModel? category) {
    categorySelected.value = category;
    if (categorySelected.value?.id == "-1") {
      listCategory.value = [...listCategoryFilterBar.value];
    } else {
      listCategory.value = [
        ...listCategoryFilterBar.value
            .where((element) => element.id == category?.id)
      ];
    }
    setState(ViewState.busy);
  }

  Future<void> getCategories() async {
    setState(ViewState.busy);
    print("getCategories");
    Result<List<CategoryModel>, Exception> getCategoriesWithAccounts =
        await sqlCategoryUsecase.getCategoriesWithAccounts();

    if (getCategoriesWithAccounts.isSuccess) {
      final categories = getCategoriesWithAccounts.data ?? [];
      listCategory.value = [...categories];
      listCategoryFilterBar.value = [...categories];
      categorySelected.value = CategoryModel(id: "-1", name: "All");
    } else {
      logError(getCategoriesWithAccounts.error);
    }
    setState(ViewState.idle);
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
      await getCategories();
      txtCategoryName.clear();
      Navigator.pop(context);
    } else {
      logError(result.error);
    }
  }

  void logError(Exception? error) {
    customLogger(msg: "$error", typeLogger: TypeLogger.error);
  }
}
