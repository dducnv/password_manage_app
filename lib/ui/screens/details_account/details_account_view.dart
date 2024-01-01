import 'package:flutter/material.dart';
import 'package:password_manage_app/ui/base/base.dart';
import 'package:password_manage_app/ui/screens/screen.dart';
import 'package:password_manage_app/ui/widgets/widgets.dart';

class DetailsAccountView extends StatefulWidget {
  const DetailsAccountView({Key? key}) : super(key: key);

  @override
  State<DetailsAccountView> createState() => _DetailsAccountViewState();
}

class _DetailsAccountViewState extends State<DetailsAccountView> {
  @override
  Widget build(BuildContext context) {
    print("build DetailsAccountView");
    return BaseView<DetailsAccountViewModel>(
      builder: (context, viewModel, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Details Account'),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer,
                              borderRadius: BorderRadius.circular(15)),
                          child: const Icon(
                            Icons.shopping_cart_rounded,
                            size: 50,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text("Google Account",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text("One-Time Password",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800])),
                  const SizedBox(height: 5),
                  const CardCustomWidget(
                    child: OtpTextWithCountdown(keySecret: "Y752SG5C5JL7UNYC"),
                  ),
                  const SizedBox(height: 10),
                  Text("Category",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800])),
                  const SizedBox(height: 5),
                  const CardCustomWidget(
                      child: Row(
                    children: [
                      Icon(Icons.folder, color: Colors.grey),
                      SizedBox(width: 10),
                      Text(
                        "Social Network",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey),
                      )
                    ],
                  )),
                  const SizedBox(height: 10),
                  Text("Thông tin đăng nhập",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800])),
                  const SizedBox(height: 5),
                  const CardCustomWidget(
                    child: Column(
                      children: [
                        ItemCoppyValue(
                          title: 'Email/Username',
                          value: 'Google Account',
                        ),
                        SizedBox(height: 10),
                        ItemCoppyValue(
                          title: 'Password',
                          value: '123456789',
                          isLastItem: true,
                          isPrivateValue: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  ValueListenableBuilder(
                    valueListenable: viewModel.isEditNote,
                    builder: (_, value, child) {
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Note",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[800])),
                              CustomButtonWidget(
                                  borderRadiusGeometry:
                                      BorderRadius.circular(50),
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .secondaryContainer,
                                  margin: const EdgeInsets.only(right: 10),
                                  padding: const EdgeInsets.all(0),
                                  text: "Edit",
                                  miniumSize: const Size(50, 15),
                                  onPressed: () {
                                    viewModel.isEditNote.value =
                                        !viewModel.isEditNote.value;
                                  },
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 3),
                                    child: Text(!value ? "Edit" : "Done",
                                        style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white)),
                                  )) // 1")),
                            ],
                          ),
                          const SizedBox(height: 5),
                          CustomTextField(
                            borderRadius: BorderRadius.circular(25),
                            contentPadding: const EdgeInsets.all(10),
                            readOnly: !value,
                            autoFocus: true,
                            borderColor: value
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.surfaceVariant,
                            requiredTextField: false,
                            textInputType: TextInputType.multiline,
                            textInputAction: TextInputAction.newline,
                            textAlign: TextAlign.start,
                            minLines: 1,
                            maxLines: null,
                            isObscure: false,
                            controller: TextEditingController(
                                text:
                                    '1e341-0351a\n5a6a4-a1f23\n04a44-99c44\nd25ad-d68e1\nf86dd-2ed33'),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text("Thông tin tuỳ chỉnh",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800])),
                  const SizedBox(height: 5),
                  const CardCustomWidget(
                    child: Column(
                      children: [
                        ItemCoppyValue(
                          title: 'Public Key',
                          value: '123456789',
                        ),
                        ItemCoppyValue(
                          title: 'Type',
                          value: 'Key for my app',
                        ),
                        SizedBox(height: 10),
                        ItemCoppyValue(
                          title: 'Private Key',
                          value: '123456789',
                          isLastItem: true,
                          isPrivateValue: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      onViewModelReady: (DetailsAccountViewModel viewModel) {},
    );
  }
}
