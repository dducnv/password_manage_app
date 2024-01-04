import 'package:flutter/material.dart';
import 'package:password_manage_app/ui/base/base.dart';
import 'package:password_manage_app/ui/screens/screen.dart';
import 'package:password_manage_app/ui/widgets/widgets.dart';

class DetailsAccountView extends StatefulWidget {
  final String id;
  const DetailsAccountView({Key? key, required this.id}) : super(key: key);

  @override
  State<DetailsAccountView> createState() => _DetailsAccountViewState();
}

class _DetailsAccountViewState extends State<DetailsAccountView> {
  @override
  Widget build(BuildContext context) {
    return BaseView<DetailsAccountViewModel>(
      builder: (context, viewModel, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text('${viewModel.account.title}',
                overflow: TextOverflow.ellipsis),
            actions: [
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.mode_edit_outline,
                    color: Colors.white,
                  ))
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Text("Thông tin đăng nhập",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800])),
                  const SizedBox(height: 5),
                  CardCustomWidget(
                    child: Column(
                      children: [
                        ItemCoppyValue(
                          title: 'Email/Username',
                          value: viewModel.account.email ?? "",
                        ),
                        const SizedBox(height: 10),
                        ItemCoppyValue(
                          title: 'Password',
                          value: viewModel.account.password ?? "",
                          isLastItem: true,
                          isPrivateValue: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text("Category",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800])),
                  const SizedBox(height: 5),
                  CardCustomWidget(
                      child: Row(
                    children: [
                      Icon(Icons.folder,
                          color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 10),
                      Text(
                        viewModel.account.category?.name ?? "",
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey),
                      )
                    ],
                  )),
                  const SizedBox(height: 10),
                  viewModel.txtNote.text.isEmpty
                      ? const SizedBox.shrink()
                      : Column(
                          children: [
                            ValueListenableBuilder(
                              valueListenable: viewModel.isEditNote,
                              builder: (_, value, child) {
                                return Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                            margin: const EdgeInsets.only(
                                                right: 10),
                                            padding: const EdgeInsets.all(0),
                                            text: "Edit",
                                            miniumSize: const Size(50, 15),
                                            onPressed: () {
                                              viewModel.isEditNote.value =
                                                  !viewModel.isEditNote.value;
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 3),
                                              child: Text(
                                                  !value ? "Edit" : "Done",
                                                  style: const TextStyle(
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.w500,
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
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : Theme.of(context)
                                              .colorScheme
                                              .surfaceVariant,
                                      requiredTextField: false,
                                      textInputType: TextInputType.multiline,
                                      textInputAction: TextInputAction.newline,
                                      textAlign: TextAlign.start,
                                      minLines: 1,
                                      maxLines: null,
                                      isObscure: false,
                                      controller: viewModel.txtNote,
                                    ),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                  Visibility(
                    visible:
                        viewModel.account.customFields?.isNotEmpty ?? false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Thông tin tuỳ chỉnh",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[800])),
                        const SizedBox(height: 5),
                        CardCustomWidget(
                          child: Column(
                            children: [
                              ...viewModel.account.customFields?.map(
                                    (e) => ItemCoppyValue(
                                      title: e.keys.first,
                                      value: e.values.firstOrNull ?? "",
                                      isPrivateValue: e["typeField"] != null
                                          ? e["typeField"]
                                              .toLowerCase()
                                              .contains("password")
                                          : false,
                                      isLastItem: viewModel
                                              .account.customFields?.last ==
                                          e,
                                    ),
                                  ) ??
                                  [],
                              const SizedBox(height: 10),
                            ],
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
      },
      onViewModelReady: (DetailsAccountViewModel viewModel) {
        viewModel.getDetailAccount(widget.id);
      },
    );
  }
}
