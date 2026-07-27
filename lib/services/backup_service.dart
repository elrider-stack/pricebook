import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';

import '../database/database_helper.dart';

class BackupService {
  BackupService._();

  static Future<String?> exportProducts() async {
    final products = await DatabaseHelper.instance.getProducts();

    final jsonData = jsonEncode(products.map((e) => e.toMap()).toList());

    final path = await FilePicker.platform.saveFile(
      dialogTitle: 'Save Backup',
      fileName: 'haidar_shop_backup.json',
      bytes: utf8.encode(jsonData),
    );

    if (path == null) return null;

    final file = File(path);

    await file.writeAsString(jsonData);

    return file.path;
  }

  static Future<File?> pickBackupFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result == null) return null;

    return File(result.files.single.path!);
  }
}
