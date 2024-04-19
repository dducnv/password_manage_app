import 'package:flutter/material.dart';
import 'package:password_manage_app/core/core.dart';
import 'package:password_manage_app/ui/base/base.dart';
import 'package:password_manage_app/ui/screens/screen.dart';
import 'package:password_manage_app/ui/widgets/widgets.dart';

class UpdateAccountViewModel extends BaseViewModel {
  CategoryUseCase sqlCategoryUsecase;
  AccountUseCase sqlAccountUsecase;

  UpdateAccountViewModel(
      {required this.sqlCategoryUsecase, required this.sqlAccountUsecase});
  final TextEditingController txtTitle = TextEditingController();
  final TextEditingController txtUsername = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();
  final TextEditingController txtFieldTitle = TextEditingController();
  final TextEditingController txtNote = TextEditingController();

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

  ValueNotifier<CategoryModel> categorySelected = ValueNotifier<CategoryModel>(
    CategoryModel(name: "Select category"),
  );

  AccountModel account = AccountModel();

  DataShared get dataShared => DataShared.instance;

  void initData() {
    notifyListeners();
  }

  void getDetailAccount(String id) async {
    setState(ViewState.busy);
    Result<AccountModel, Exception> getAccount =
        await sqlAccountUsecase.getAccount(id);
    if (getAccount.isSuccess) {
      account = getAccount.data ?? AccountModel();
      id = account.id ?? "";
      fillOldData();
    } else {
      customLogger(msg: "${getAccount.error}", typeLogger: TypeLogger.error);
    }
    setState(ViewState.idle);
  }

  void fillOldData() {
    txtNote.text = account.note ?? "";
    txtTitle.text = account.title ?? "";
    txtUsername.text = account.email ?? "";
    txtPassword.text =
        account.password != "" ? decodePassword(account.password!) : "";
    categorySelected.value =account.category ?? categorySelected.value;

    for (Map<String, dynamic> customField in account.customFields ?? []) {
      handleAddField(
        type: typeTextFields
            .where((element) => element.type == customField['typeField'])
            .first,
        hintText: customField["hintText"] ?? "",
        keyField: customField.keys.first,
        value: customField.values.first,
      );
    }
  }

  void handleUpdateAccount({
    required BuildContext context,
  }) async {
    setState(ViewState.busy);
    if (txtTitle.text.isEmpty) {
      return;
    }

    if (categorySelected.value.name == "Select category") {
      return;
    }

    String titleEncrypted = EncryptData.instance.encryptFernet(
      key: Env.infoEncryptKey,
      value: txtTitle.text,
    );

    String usernameEncrypted = txtUsername.text != ""
        ? EncryptData.instance.encryptFernet(
            key: Env.infoEncryptKey,
            value: txtUsername.text,
          )
        : "";

    String passwordEncrypted = txtPassword.text != ""
        ? EncryptData.instance.encryptFernet(
            key: Env.infoEncryptKey,
            value: txtPassword.text,
          )
        : "";

    String noteEncrypted = txtNote.text != ""
        ? EncryptData.instance.encryptFernet(
            key: Env.infoEncryptKey,
            value: txtNote.text,
          )
        : "";

    account.title = titleEncrypted;
    account.email = usernameEncrypted;
    account.password = passwordEncrypted;
    account.note = noteEncrypted;
    account.category = categorySelected.value;
    account.customFields = dynamicTextFieldNotifier.value
        .map((e) => {
              e.customField.key: e.controller.text,
              "typeField": e.customField.typeField.type,
              "hintText": e.customField.hintText
            })
        .toList();
    Result<bool, Exception> updateAccount =
        await sqlAccountUsecase.updateAccount(account);
    if (updateAccount.isSuccess) {
      dataShared.getCategories();
      dataShared.getAccounts();
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop({
        "updated": true,
      });
    } else {
      customLogger(msg: "${updateAccount.error}", typeLogger: TypeLogger.error);
    }
    setState(ViewState.idle);
  }

  Widget fieldCustom({
    required TextEditingController controller,
    required String key,
    required String type,
    required String hintText,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: CustomTextField(
              requiredTextField: false,
              titleTextField: hintText,
              controller: controller,
              textInputAction: TextInputAction.next,
              textAlign: TextAlign.start,
              hintText: hintText,
              isObscure: type == "password" ? true : false,
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
  }

  void handleAddField(
      {TypeTextField? type,
      String? keyField,
      String? value,
      String? hintText}) {
    final controller = TextEditingController(text: value ?? "");
    final key = keyField ??
        txtFieldTitle.text.toLowerCase().trim().replaceAll(" ", "_");
    final field = fieldCustom(
        controller: controller,
        key: key,
        hintText: hintText ?? txtFieldTitle.text,
        type: type?.type ?? typeTextFieldSelected.value.type);

    dynamicTextFieldNotifier.value.add(
      DynamicTextField(
        key: key,
        controller: controller,
        customField: CustomField(
            key: key,
            hintText: hintText ?? txtFieldTitle.text,
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
