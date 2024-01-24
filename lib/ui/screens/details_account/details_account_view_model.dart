import 'package:flutter/material.dart';
import 'package:password_manage_app/core/core.dart';
import 'package:password_manage_app/ui/base/base.dart';

class DetailsAccountViewModel extends BaseViewModel {
  final AccountUseCase sqlAccountUsecase;

  DetailsAccountViewModel({required this.sqlAccountUsecase});
  ValueNotifier<bool> isEditNote = ValueNotifier(false);

  TextEditingController txtNote = TextEditingController();
  AccountModel account = AccountModel();

  String id = "";

  void getDetailAccount(String id) async {
    setState(ViewState.busy);
    Result<AccountModel, Exception> getAccount =
        await sqlAccountUsecase.getAccount(id);
    if (getAccount.isSuccess) {
      account = getAccount.data ?? AccountModel();
      id = account.id ?? "";
      txtNote.text = account.note ?? "";
    } else {
      customLogger(msg: "${getAccount.error}", typeLogger: TypeLogger.error);
    }
    setState(ViewState.idle);
  }

  void handleUpdateNote() async {
    setState(ViewState.busy);
    if (isEditNote.value == false) {
      isEditNote.value = true;
      setState(ViewState.idle);
      return;
    }
    if (account.note == txtNote.text) {
      isEditNote.value = false;
      setState(ViewState.idle);
      return;
    }

    account.note = txtNote.text;

    customLogger(msg: "${account.id}", typeLogger: TypeLogger.info);

    Result<bool, Exception> updateAccount =
        await sqlAccountUsecase.updateAccount(account);
    if (updateAccount.isSuccess) {
      isEditNote.value = false;
    } else {
      customLogger(msg: "${updateAccount.error}", typeLogger: TypeLogger.error);
    }
    setState(ViewState.idle);
  }
}
