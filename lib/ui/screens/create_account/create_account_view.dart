import 'package:flutter/material.dart';
import 'package:password_manage_app/core/services/otp_generator.dart';
import 'package:password_manage_app/ui/base/base.dart';
import 'package:password_manage_app/ui/route/route.dart';
import 'package:password_manage_app/ui/screens/create_account/components/create_account_components.dart';
import 'package:password_manage_app/ui/screens/screen.dart';
import 'package:password_manage_app/ui/widgets/widgets.dart';

class CreateAccountView extends StatefulWidget {
  const CreateAccountView({Key? key}) : super(key: key);

  @override
  State<CreateAccountView> createState() => CreateAccountViewState();
}

class CreateAccountViewState extends State<CreateAccountView> {
  @override
  Widget build(BuildContext context) {
    return BaseView<CreateAccountViewModel>(
      builder: (__, viewModel, _) {
        return Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                viewModel.printValues();
              },
              child: const Icon(Icons.check),
            ),
            appBar: AppBar(
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
                    DoubleValueListenBuilder<bool, String>(
                      viewModel.isEnterOTPFromKeyboard,
                      viewModel.keyAuthentication,
                      builder: (_, isEnterOTPFromKeyboard, keyAuthentication,
                          child) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Khóa xác thực 2 lớp (TOTP)",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[800]),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            viewModel.keyAuthentication.value.isNotEmpty
                                ? Row(
                                    children: [
                                      Expanded(
                                        child: CardCustomWidget(
                                          child: OtpTextWithCountdown(
                                            keySecret:
                                                viewModel.txtKeySetOTP.text,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      IconButton(
                                        tooltip: isEnterOTPFromKeyboard == true
                                            ? "Ẩn ô nhập"
                                            : "Hiện ô nhập",
                                        onPressed: () {
                                          viewModel.handleClearKeyAuth();
                                        },
                                        icon: const Icon(Icons.cancel_outlined),
                                      )
                                    ],
                                  )
                                : Row(
                                    children: [
                                      Expanded(
                                        child: isEnterOTPFromKeyboard
                                            ? CustomTextField(
                                                requiredTextField: true,
                                                controller:
                                                    viewModel.txtKeySetOTP,
                                                textInputAction:
                                                    TextInputAction.go,
                                                textAlign: TextAlign.start,
                                                onFieldSubmitted: (value) {},
                                                autoFocus: true,
                                                hintText:
                                                    "Nhập khóa xác thực 2 lớp",
                                                isObscure: false,
                                                maxLines: 1,
                                              )
                                            : CustomButtonWidget(
                                                margin: const EdgeInsets.all(0),
                                                border: Border.all(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .surfaceVariant),
                                                onPressed: () async {
                                                  var uri =
                                                      await Navigator.pushNamed(
                                                          context,
                                                          RoutePaths
                                                              .qrcodeScaner);

                                                  if (uri != null) {
                                                    var otpCustom =
                                                        OTPCustom.fromUri(
                                                                uri.toString())
                                                            .toJson();
                                                    viewModel
                                                        .handleShowTextFieldEnterOTP();
                                                    viewModel
                                                            .txtKeySetOTP.text =
                                                        otpCustom['secret'];
                                                    viewModel.keyAuthentication
                                                            .value =
                                                        otpCustom['secret'];

                                                    viewModel.txtTitle.text =
                                                        otpCustom['issuer'];

                                                    viewModel.txtUsername.text =
                                                        otpCustom[
                                                            'accountName'];
                                                  }
                                                },
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .secondaryContainer,
                                                text: "",
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Icon(
                                                        Icons
                                                            .qr_code_scanner_rounded,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      'Thêm khóa xác thực 2 lớp',
                                                      style: TextStyle(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .primary),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      IconButton(
                                          tooltip:
                                              isEnterOTPFromKeyboard == true
                                                  ? "Ẩn ô nhập"
                                                  : "Hiện ô nhập",
                                          onPressed: () {
                                            viewModel
                                                .handleShowTextFieldEnterOTP();
                                          },
                                          icon: Icon(isEnterOTPFromKeyboard ==
                                                  true
                                              ? Icons.cancel_outlined
                                              : Icons.keyboard_alt_outlined)),
                                    ],
                                  ),
                            isEnterOTPFromKeyboard &&
                                    viewModel.keyAuthentication.value.isEmpty
                                ? CustomButtonWidget(
                                    margin: const EdgeInsets.only(top: 10),
                                    border: Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surfaceVariant),
                                    onPressed: () {},
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .secondaryContainer,
                                    text: "",
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Icon(Icons.check,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          'Thêm khóa',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary),
                                        ),
                                      ],
                                    ),
                                  )
                                : const SizedBox.shrink()
                          ],
                        );
                      },
                    ),
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
      onViewModelReady: (CreateAccountViewModel viewModel) {},
    );
  }
}
