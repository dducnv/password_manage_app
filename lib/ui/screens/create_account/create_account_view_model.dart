import 'package:flutter/material.dart';
import 'package:password_manage_app/core/core.dart';
import 'package:password_manage_app/core/utils/logger.dart';
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

  ValueNotifier<List<DynamicTextField>> dynamicTextFieldNotifier =
      ValueNotifier<List<DynamicTextField>>([]);

  ValueNotifier<bool> isEnterOTPFromKeyboard = ValueNotifier<bool>(false);

  List<TypeTextField> typeTextFields = [
    TypeTextField(title: 'Text', type: 'text'),
    TypeTextField(title: 'Password', type: 'password'),
  ];

  ValueNotifier<TypeTextField> typeTextFieldSelected =
      ValueNotifier<TypeTextField>(
    TypeTextField(title: 'Text', type: 'text'),
  );

  final ValueNotifier<List<CategoryModel>> listCategory =
      ValueNotifier<List<CategoryModel>>([]);

  ValueNotifier<CategoryModel> categorySelected =
      ValueNotifier<CategoryModel>(CategoryModel(name: "Select category"));

  void initData() {
    typeTextFieldSelected.value = typeTextFields[0];
    dynamicTextFieldNotifier.value = [];
    txtTitle.clear();
    txtUsername.clear();
    txtPassword.clear();
    txtFieldTitle.clear();

    getCategories();
    getAccounts();
    notifyListeners();
  }

  void handleShowTextFieldEnterOTP() {
    isEnterOTPFromKeyboard.value = !isEnterOTPFromKeyboard.value;
    setState(ViewState.busy);
  }

  void getCategories() async {
    Result<List<CategoryModel>, Exception> listCategory =
        await sqlCategoryUsecase.getCategories();
    if (listCategory.isSuccess) {
      this.listCategory.value = listCategory.data ?? [];
    } else {}
  }

  Future<void> getAccounts() async {
    Result<List<AccountModel>, Exception> listAccounts =
        await sqlAccountUsecase.getAccounts();

    for (AccountModel account in listAccounts.data ?? []) {
      customLogger(msg: "${account.toJson()}", typeLogger: TypeLogger.info);
    }
  }

  Future<void> handleInsertAccount({
    required BuildContext context,
  }) async {
    printValues();
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
              })
          .toList(),
    );

    Result<bool, Exception> result =
        await sqlAccountUsecase.saveAccount(account);
    if (result.isSuccess) {
      resetFields();
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop({
        "isSuccess": true,
      });
      customLogger(msg: "Create account success", typeLogger: TypeLogger.info);
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
