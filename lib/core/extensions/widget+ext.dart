import 'package:flutter/material.dart';
import 'package:password_manage_app/core/utils/dialog_content.dart';

extension WidgetExt on Widget {
  void showCustomDialog(BuildContext context, DialogContent dialogContent) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text(dialogContent.title),
            content: Text(dialogContent.content),
            actions: dialogContent.buttons
                .asMap()
                .map((index, button) => MapEntry(
                    index,
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        dialogContent.buttonActions[index]();
                      },
                      child: Text(button),
                    )))
                .values
                .toList(),
          );
        });
  }

  void hideKeyBoard(BuildContext context) {
    final currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }
}
