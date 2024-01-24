import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:password_manage_app/core/core.dart';
import 'package:password_manage_app/ui/base/base.dart';
import 'package:password_manage_app/ui/screens/create_account/components/create_account_components.dart';
import 'package:password_manage_app/ui/screens/screen.dart';
import 'package:password_manage_app/ui/widgets/widgets.dart';

class CreateAccountView extends StatefulWidget {
  final CategoryModel categoryModel;
  const CreateAccountView({Key? key, required this.categoryModel})
      : super(key: key);

  @override
  State<CreateAccountView> createState() => CreateAccountViewState();
}

class CreateAccountViewState extends State<CreateAccountView> {
  bool isCreatedCategory = false;
  @override
  Widget build(BuildContext context) {
    return BaseView<CreateAccountViewModel>(
      builder: (__, viewModel, _) {
        return Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                viewModel.printValues();
                viewModel.handleInsertAccount(
                  context: context,
                );
              },
              child: const Icon(Icons.check),
            ),
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop({"filter": "reload"});
                },
              ),
              elevation: 0,
              scrolledUnderElevation: 0,
              title: const Text('Create Account'),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    CustomTextField(
                      requiredTextField: true,
                      titleTextField: "Tên ứng dụng",
                      controller: viewModel.txtTitle,
                      textInputAction: TextInputAction.next,
                      textAlign: TextAlign.start,
                      hintText: "Tên ứng dụng",
                      autoFocus:true,
                      maxLines: 1,
                      isObscure: false,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                      requiredTextField: true,
                      titleTextField: "Email/Tên tài khoản",
                      controller: viewModel.txtUsername,
                      textInputAction: TextInputAction.next,
                      textAlign: TextAlign.start,
                      hintText: "Email/Tên tài khoản",
                      maxLines: 1,
                      isObscure: false,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                      requiredTextField: true,
                      titleTextField: "Password",
                      controller: viewModel.txtPassword,
                      textInputAction: TextInputAction.next,
                      textAlign: TextAlign.start,
                      hintText: "Password",
                      isObscure: true,
                      maxLines: 1,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ValueListenableBuilder(
                        valueListenable: viewModel.categorySelected,
                        builder: (context, value, child) {
                          return CustomTextField(
                            requiredTextField: true,
                            readOnly: true,
                            suffixIcon: const Icon(Icons.keyboard_arrow_down),
                            titleTextField: "Select Category",
                            controller: TextEditingController(),
                            textInputAction: TextInputAction.next,
                            textAlign: TextAlign.start,
                            hintText: value.name,
                            maxLines: 1,
                            isObscure: false,
                            onTap: () {
                              bottomSheetSelectCategory(
                                viewModel: viewModel,
                              );
                            },
                          );
                        }),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                      requiredTextField: false,
                      titleTextField: "Ghi chú",
                      textInputType: TextInputType.multiline,
                      controller: viewModel.txtNote,
                      textInputAction: TextInputAction.newline,
                      textAlign: TextAlign.start,
                      hintText: "Ghi chú",
                      minLines: 1,
                      maxLines: null,
                      isObscure: false,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    viewModel.txtNote.text.isNotEmpty
                        ? CustomTextField(
                            contentPadding: const EdgeInsets.all(10),
                            readOnly: true,
                            borderColor:
                                Theme.of(context).colorScheme.surfaceVariant,
                            requiredTextField: false,
                            titleTextField: "Ghi chú",
                            textInputType: TextInputType.multiline,
                            controller: viewModel.txtNote,
                            textInputAction: TextInputAction.newline,
                            textAlign: TextAlign.start,
                            hintText: "Ghi chú",
                            minLines: 1,
                            maxLines: null,
                            isObscure: false,
                          )
                        : const SizedBox.shrink(),
                    ValueListenableBuilder(
                        valueListenable: viewModel.dynamicTextFieldNotifier,
                        builder: (context, value, child) {
                          return Column(
                            children: List.generate(value.length, (index) {
                              return value[index].field;
                            }),
                          );
                        }),
                    CustomButtonWidget(
                      border: Border.all(
                          color: Theme.of(context).colorScheme.surfaceVariant),
                      onPressed: () {
                        bottomSheetAddCustomField(
                          context,
                          controller: viewModel.txtFieldTitle,
                          onAddField: () {
                            viewModel.handleAddField();
                          },
                          typeTextFields: viewModel.typeTextFields,
                          typeTextFieldSelected:
                              viewModel.typeTextFieldSelected,
                        );
                      },
                      backgroundColor:
                          Theme.of(context).colorScheme.secondaryContainer,
                      margin: const EdgeInsets.only(top: 16),
                      text: "",
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          Icon(Icons.add,
                              color: Theme.of(context).colorScheme.primary),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Thêm trường',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ));
      },
      onViewModelReady: (CreateAccountViewModel viewModel) {
        viewModel.initData();
        if (widget.categoryModel.id != "-1") {
          viewModel.categorySelected.value = widget.categoryModel;
        }
      },
    );
  }
}
