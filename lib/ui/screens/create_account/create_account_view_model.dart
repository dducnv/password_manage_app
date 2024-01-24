import 'package:flutter/material.dart';
import 'package:password_manage_app/core/core.dart';
import 'package:password_manage_app/ui/base/base.dart';
import 'package:password_manage_app/ui/widgets/widgets.dart';

class CreateAccountViewModel extends BaseViewModel {
  CategoryUseCase sqlCategoryUsecase;
  AccountUseCase sqlAccountUsecase;

  CreateAccountViewModel(
      {required this.sqlCategoryUsecase, required this.sqlAccountUsecase});
  final TextEditingController txtTitle = TextEditingController();
  final TextEditingController txtUsername = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();
  final TextEditingController txtFieldTitle = TextEditingController();
  final TextEditingController txtNote = TextEditingController();
  final TextEditingController txtCategoryName = TextEditingController();

  ValueNotifier<List<DynamicTextField>> dynamicTextFieldNotifier =
      ValueNotifier<List<DynamicTextField>>([]);

  List<TypeTextField> typeTextFields = [
    TypeTextField(title: 'Text', type: 'text'),
    TypeTextField(title: 'Password', type: 'password'),
  ];

  ValueNotifier<TypeTextField> typeTextFieldSelected =
      ValueNotifier<TypeTextField>(
    TypeTextField(title: 'Text', type: 'text'),
  );

  ValueNotifier<CategoryModel> categorySelected =
      ValueNotifier<CategoryModel>(CategoryModel(name: "Select category"));

  DataShared get dataShared => DataShared.instance;

  void initData() {
    typeTextFieldSelected.value = typeTextFields[0];
    dynamicTextFieldNotifier.value = [];
    txtTitle.clear();
    txtUsername.clear();
    txtPassword.clear();
    txtFieldTitle.clear();

    notifyListeners();
  }

  Future<void> handleInsertAccount({
    required BuildContext context,
  }) async {
    printValues();
    //validate
    if (txtTitle.text.isEmpty) {
      return;
    }

    if (txtUsername.text.isEmpty) {
      return;
    }

    if (txtPassword.text.isEmpty) {
      return;
    }

    if (categorySelected.value.name == "Select category") {
      return;
    }

    AccountModel account = AccountModel(
      title: txtTitle.text,
      email: txtUsername.text,
      password: txtPassword.text,
      note: txtNote.text,
      category: categorySelected.value,
      customFields: dynamicTextFieldNotifier.value
          .map((e) => {
                e.customField.key: e.controller.text,
                "typeField": e.customField.typeField.type,
                "hintText": e.customField.hintText
              })
          .toList(),
    );

    Result<bool, Exception> result =
        await sqlAccountUsecase.saveAccount(account);
    if (result.isSuccess) {
      resetFields();
      // ignore: use_build_context_synchronously
      dataShared.getAccounts();
      dataShared.getCategories();

      customLogger(msg: "Create account success", typeLogger: TypeLogger.info);
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop({"filter": "reload"});
    } else {
      customLogger(
          msg: "Create account error ${result.error}",
          typeLogger: TypeLogger.error);
    }
  }

  void printValues() {
    customLogger(msg: '''
      title: ${txtTitle.text}
      username: ${txtUsername.text}
      password: ${txtPassword.text}
      note: ${txtNote.text}
     ''', typeLogger: TypeLogger.info);
    for (var element in dynamicTextFieldNotifier.value) {
      customLogger(
          msg:
              "${element.customField.key}(${element.customField.typeField.type}) :  ${element.controller.text}",
          typeLogger: TypeLogger.info);
    }
  }

  void resetFields() {
    txtTitle.clear();
    txtUsername.clear();
    txtPassword.clear();
    txtNote.clear();
    dynamicTextFieldNotifier.value = [];
    notifyListeners();
  }

  void handleAddField() {
    final controller = TextEditingController();
    final key = txtFieldTitle.text.toLowerCase().trim().replaceAll(" ", "_");
    final field = Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: CustomTextField(
              requiredTextField: false,
              titleTextField: txtFieldTitle.text,
              controller: controller,
              textInputAction: TextInputAction.next,
              textAlign: TextAlign.start,
              hintText: txtFieldTitle.text,
              isObscure:
                  typeTextFieldSelected.value.type == "password" ? true : false,
              maxLines: 1,
            ),
          ),
          IconButton(
            onPressed: () {
              dynamicTextFieldNotifier.value
                  .removeWhere((element) => element.key == key);
              notifyListeners();
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
    );

    dynamicTextFieldNotifier.value.add(
      DynamicTextField(
        key: key,
        controller: controller,
        customField: CustomField(
            key: txtFieldTitle.text.toLowerCase().trim().replaceAll(" ", "_"),
            hintText: txtFieldTitle.text,
            typeField: typeTextFieldSelected.value),
        field: field,
      ),
    );
    txtFieldTitle.clear();

    notifyListeners();
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
      Navigator.of(context).pop();
    } else {
      customLogger(msg: result.error.toString(), typeLogger: TypeLogger.error);
    }
  }

  @override
  void dispose() {
    for (var element in dynamicTextFieldNotifier.value) {
      element.controller.dispose();
    }
    super.dispose();
  }
}

class DynamicTextField {
  final String key;

  final TextEditingController controller;
  final Widget field;
  final CustomField customField;
  DynamicTextField({
    required this.key,
    required this.controller,
    required this.customField,
    required this.field,
  });
}

class CustomField {
  final String key;
  final String hintText;
  final TypeTextField typeField;

  CustomField({
    required this.key,
    required this.hintText,
    required this.typeField,
  });
}
