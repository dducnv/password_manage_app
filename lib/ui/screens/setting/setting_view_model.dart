import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:password_manage_app/core/core.dart';
import 'package:password_manage_app/ui/base/base.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SettingViewModel extends BaseViewModel {
  ValueNotifier<ThemeMode> themeMode =
      ValueNotifier<ThemeMode>(ThemeMode.system);

  DataShared get dataShared => DataShared.instance;

  void changeThemeMode(ThemeMode mode) {
    themeMode.value = mode;

    notifyListeners();
  }

  Future<File> _getDownloadFile(String fileName) async {
    Directory? path = Directory("/storage/emulated/0/Download");
    if (!path.existsSync()) {
      path = await getExternalStorageDirectory();
    }
    return File('${path!.path}/$fileName');
  }

  Future<String> exportDbAsCrypt(BuildContext context) async {
    String path = await getDatabasesPath();
    path = join(path, 'passwordManager.db');
    List<int> bytes = File(path).readAsBytesSync();
    final codeEncrypted = EncryptData.instance
        .encryptFernetBytes(data: bytes, key: Env.fileEncryptKey);
    String encryptedString = base64.encode(codeEncrypted);
    File outputFile = await _getDownloadFile('password_manage_backup.crypt');
// ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("data backup successful"),
    ));
    await outputFile.writeAsString(encryptedString, flush: true);
    return outputFile.path;
  }

  Future<void> importDbAsCrypt() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File file = File(result.files.single.path!);
      String content = await file.readAsString();
      List<int> bytes = base64.decode(content);
      final decryptedBytes = EncryptData.instance.decryptFernetBytes(
        encryptedData: bytes,
        key: Env.fileEncryptKey,
      );
      String path = await getDatabasesPath();
      path = join(path, 'passwordManager.db');
      File(path).writeAsBytesSync(decryptedBytes);

      dataShared.getCategories();
      dataShared.getAccounts();
    }
  }
}
