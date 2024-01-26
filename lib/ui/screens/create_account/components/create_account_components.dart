import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:password_manage_app/core/core.dart';
import 'package:password_manage_app/ui/screens/screen.dart';
import 'package:password_manage_app/ui/widgets/widgets.dart';

extension CretaeAccountComponent on CreateAccountViewState {
  Future<void> bottomSheetAddCustomField(
    BuildContext context, {
    required TextEditingController controller,
    required Function() onAddField,
    required List<TypeTextField> typeTextFields,
    required ValueNotifier<TypeTextField> typeTextFieldSelected,
  }) {
    return showModalBottomSheet(
      backgroundColor: Theme.of(context).colorScheme.background,
      elevation: 0,
      isScrollControlled: true,
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        height: MediaQuery.of(context).size.height * 0.8,
        child: SingleChildScrollView(
          dragStartBehavior: DragStartBehavior.down,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                requiredTextField: true,
                titleTextField: "Tên trường",
                controller: controller,
                textInputAction: TextInputAction.next,
                textAlign: TextAlign.start,
                hintText: "Tên trường",
                maxLines: 1,
                isObscure: false,
              ),
              const SizedBox(height: 10),
              RichText(
                text: TextSpan(
                    text: "Loại trường: ",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800]),
                    children: const <TextSpan>[
                      TextSpan(
                          text: '*',
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 16)),
                    ]),
              ),
              const SizedBox(height: 5),
              ValueListenableBuilder(
                  valueListenable: typeTextFieldSelected,
                  builder: (context, value, child) {
                    return ListView.separated(
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: typeTextFields.length,
                      itemBuilder: (context, index) {
                        return CustomButtonWidget(
                          onPressed: () {
                            typeTextFieldSelected.value = typeTextFields[index];
                          },
                          backgroundColor:
                              Theme.of(context).colorScheme.secondaryContainer,
                          margin: const EdgeInsets.all(0),
                          text: "",
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(
                                width: 10,
                              ),
                              Radio<TypeTextField>(
                                value: typeTextFields[index],
                                groupValue: typeTextFieldSelected.value,
                                onChanged: (TypeTextField? value) {
                                  typeTextFieldSelected.value = value!;
                                },
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                typeTextFields[index].title,
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }),
              const SizedBox(height: 16),
              CustomButtonWidget(
                margin: const EdgeInsets.all(0),
                onPressed: () {
                  onAddField();
                  Navigator.pop(context);
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
                      "Thêm trường",
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
            ],
          ),
        ),
      ),
    );
  }

  Future<void> bottomSheetSelectCategory({
    required CreateAccountViewModel viewModel,
  }) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            height: MediaQuery.of(context).size.height * 0.8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                          "Chọn danh mục (${viewModel.dataShared.categoryListForFilterBar.value.length})"),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: IconButton(
                          onPressed: () {
                            bottomSheetCreateCategory(
                                context: context, viewModel: viewModel);
                          },
                          icon: const Icon(Icons.add)),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                ValueListenableBuilder(
                    valueListenable:
                        viewModel.dataShared.categoryListForFilterBar,
                    builder: (context, cateList, child) {
                      return Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: cateList.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              selected: viewModel.categorySelected.value ==
                                  cateList[index],
                              onTap: () {
                                viewModel.categorySelected.value =
                                    cateList[index];
                                Navigator.pop(context);
                              },
                              leading: Icon(
                                Icons.folder,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              title: Text(
                                cateList[index].name ?? "",
                              ),
                            );
                          },
                        ),
                      );
                    })
              ],
            ),
          );
        });
  }

  Future<void> bottomSheetCreateCategory({
    required BuildContext context,
    required CreateAccountViewModel viewModel,
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



}
