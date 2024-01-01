import 'package:flutter/material.dart';
import 'package:password_manage_app/core/core.dart';
import 'package:password_manage_app/core/utils/utils.dart';
import 'package:password_manage_app/ui/base/base.dart';
import 'package:password_manage_app/ui/widgets/widgets.dart';

class CreateAccountViewModel extends BaseViewModel {
  final TextEditingController txtTitle = TextEditingController();
  final TextEditingController txtUsername = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();
  final TextEditingController txtFieldTitle = TextEditingController();
  final TextEditingController txtKeySetOTP = TextEditingController();
  final TextEditingController txtNote = TextEditingController();

  ValueNotifier<List<DynamicTextField>> dynamicTextFieldNotifier =
      ValueNotifier<List<DynamicTextField>>([]);

  ValueNotifier<bool> isEnterOTPFromKeyboard = ValueNotifier<bool>(false);

  List<TypeTextField> typeTextFields = [
    TypeTextField(title: 'Text', type: 'text'),
    TypeTextField(title: 'Password', type: 'password'),
  ];

  ValueNotifier<String> keyAuthentication = ValueNotifier<String>("");
  ValueNotifier<TypeTextField> typeTextFieldSelected =
      ValueNotifier<TypeTextField>(
    TypeTextField(title: 'Text', type: 'text'),
  );

  void initData() {
    typeTextFieldSelected.value = typeTextFields[0];
    dynamicTextFieldNotifier.value = [];
    txtTitle.clear();
    txtUsername.clear();
    txtPassword.clear();
    txtFieldTitle.clear();

    notifyListeners();
  }

  void handleShowTextFieldEnterOTP() {
    isEnterOTPFromKeyboard.value = !isEnterOTPFromKeyboard.value;
    setState(ViewState.busy);
  }

  void handleClearKeyAuth() {
    keyAuthentication.value = "";
    isEnterOTPFromKeyboard = ValueNotifier<bool>(false);
    notifyListeners();
  }

  void printValues() {
    print("title: ${txtTitle.text}");
    print("username: ${txtUsername.text}");
    print("password: ${txtPassword.text}");
    for (var element in dynamicTextFieldNotifier.value) {
      print("${element.customField.key}:  ${element.controller.text}");
      print("type: ${element.customField.typeField.type}");
    }

    print("key auth: ${keyAuthentication.value}");
    print("note: ${txtNote.text}");

    print("hello\n world");
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
