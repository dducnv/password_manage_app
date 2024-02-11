import 'package:flutter/material.dart';
import 'package:password_manage_app/core/core.dart';
import 'package:password_manage_app/ui/route/route.dart';
import 'package:password_manage_app/ui/screens/screen.dart';
import 'package:password_manage_app/ui/widgets/widgets.dart';

extension HomeComponent on HomeViewState {
  Future<void> bottomSheetCreateCategory({
    required BuildContext context,
    required HomeViewModel viewModel,
  }) async {
    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return Builder(builder: (BuildContext context) {
          return Container(
            padding: const EdgeInsets.all(16),
            height: 170 + MediaQuery.of(context).viewInsets.bottom,
            child: SingleChildScrollView(
              child: Column(children: [
                CustomTextField(
                    autoFocus: true,
                    requiredTextField: true,
                    titleTextField: "Tên danh mục",
                    controller: viewModel.txtCategoryName,
                    textInputAction: TextInputAction.go,
                    textAlign: TextAlign.start,
                    hintText: "Nhập tên danh mục",
                    maxLines: 1,
                    isObscure: false,
                    onFieldSubmitted: (value) {
                      viewModel.handleCreateCategory(
                        context: context,
                      );
                    }),
                const SizedBox(height: 16),
                CustomButtonWidget(
                  margin: const EdgeInsets.all(0),
                  onPressed: () {
                    viewModel.handleCreateCategory(
                      context: context,
                    );
                  },
                  text: "",
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      Text(
                        "Thêm danh mục",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          );
        });
      },
      isScrollControlled: true,
    );
  }

  Future<void> bottomSheetOptionAccountItem({
    required BuildContext context,
    required HomeViewModel viewModel,
    required AccountModel accountModel,
  }) async {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info),
                  title: const Text("Chi tiết"),
                  onTap: () {
                    Navigator.pushNamed(context, RoutePaths.detailsAccount,
                        arguments: {"id": accountModel.id}).then((value) {});
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.edit),
                  title: const Text("Chỉnh sửa"),
                  onTap: () async {
                    Navigator.pop(context);
                    dynamic statusUpdate = await Navigator.pushNamed(
                        context, RoutePaths.updateAccount,
                        arguments: {"id": accountModel.id});
                    if (statusUpdate != null && statusUpdate == true) {
                      viewModel.handleFilterByCategory(
                          viewModel.categorySelected.value);

                          Future.delayed(const Duration(milliseconds: 100), () {
                            Navigator.pop(context);
                          });
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete),
                  title: const Text("Xóa tài khoản"),
                  onTap: () {
                    viewModel.handleDeleteAccount(
                      context: context,
                      accountModel: accountModel,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
