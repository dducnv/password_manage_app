import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:password_manage_app/core/utils/utils.dart';
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
}

// Container(
//                     clipBehavior: Clip.antiAlias,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       border: Border.all(color: Colors.grey.shade300),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: ListTile(
//                       contentPadding: EdgeInsets.zero,
//                       leadingAndTrailingTextStyle: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w500,
//                       ),
//                       minLeadingWidth: 0,
//                       onTap: () {
//                         typeTextFieldSelected = typeTextField[index];
//                         onChangeTypeField(typeTextField[index]);
//                       },
//                       title: Text(typeTextField[index].title),
//                       leading: Radio(
//                         value: typeTextField[index],
//                         groupValue: typeTextFieldSelected,
//                         onChanged: (TypeTextField? value) {
//                           typeTextFieldSelected = typeTextField[index];
//                           onChangeTypeField(value!);
//                         },
//                       ),
//                     ),
//                   );

